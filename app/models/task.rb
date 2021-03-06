class Task < ActiveRecord::Base
  require 'gcm'
  require 'json'
  require 'thread'
  	#Tiene versionamiento de datos
	has_paper_trail
	@@sending = false

	#Una tarea puede tener muchos hijos, y cada tarea tiene a lo más un padre.
	has_many :children, foreign_key: 'parent_id', class_name: 'Task', dependent: :destroy
	belongs_to :parent, class_name: 'Task'

	#Una tarea tiene muchos reportes
	has_many :reports, dependent: :destroy

	has_many :indicators, dependent: :destroy

	#Una tarea tiene un dueño
	belongs_to :user

	#Una tarea pertenece a un proyecto
	belongs_to :project

	#Tiene muchos comentarios
	has_many :comments

	# after_commit :call_update, on: [:create, :update, :destroy]

	scope :done, -> { where(progress: 100) }
	scope :not_done, -> { where.not(progress: 100) }
	scope :by_level, -> (order: :desc){ order(level: order) }
	scope :in_level, -> (level) { where(level: level) }
	scope :by_id, -> (order: :asc){order(mpp_uid: order)}

	#que el nombre este presente al crear/editar la tarea
	validates :name, presence: true

	#validacion para que la fecha de fin sea posterior a la de comienzo
	validates_presence_of :expected_start_date
	validates_presence_of :expected_end_date
	validate :end_date_is_after_start_date

	# Si cambio el responsable, que toda la descendencia quede con ese responsable	
	after_save :check_parent_user
	# after_create :set_duration

	# cada vez que se modifica o elimina una task, actualizamos todo el arbol sobre ella. #######################
	# after_save :update_tree_over_me
	# before_destroy :leave_the_world_in_order

	#Verificamos que la fecha de termino sea menor a la fecha de inicio
	def end_date_is_after_start_date
		return if expected_end_date.blank? || expected_start_date.blank?
		if expected_end_date < expected_start_date
			errors.add(:expected_end_date, "La fecha de término debe ser posterior a la de inicio")
		end 
  	end



	def call_update
		if(@@sending)
			return
		end

		@@sending=true
		Thread.new{
			gcm = GCM.new("AIzaSyA9FUIkOt3xAzydK15ZqeKuOHp0frmcKUs")
			registration_id=[]
			#Este metodo llama a todos los usuarios de un proyecto y les avisa que actualice el expected_progress.
			project_id = self.project_id
			projecto = Project.find(project_id)
			usuarios = projecto.users
			usuarios.each do |user|
				Rails.logger.info "Enviando notificacion..."
				#Tengo que buscar en la tabla y enviar un mensaje a cada uno avisando que actualicen!.
				pushNotification = Push.where(:mail => user.email)
				if (!pushNotification.blank?)
					#Significa que el usuario tiene un token asignado. Le mando una push notification.
					pushNotification.each do |notification|
						registration_id << notification.token
						data = {data: {project_id: project_id}}.to_json
						response = gcm.send(registration_id, JSON.parse(data))
						Rails.logger.info "Respuesta Notificacion:"
						Rails.logger.info response
					end
				end
			end
			@@sending=false
		}
	end


  


	




# METODOS HELPERS ############################################################################





	# calcula el costo de la tarea sumando el de las tareas hijas 
	# o entrega su propio resources cost si no tiene hijas
	def resources_total_cost
		if has_children?
			children.includes(:children).map(&:resources_total_cost).inject(:+)
		else
			resources_cost
		end
	end

	# metodo para setear el nivel de profundidad de la tarea
	def set_level
	   self.level = parent ? parent.level + 1 : 1
	end

	def enterprise
		project.enterprise
	end

	def f_dates
		array = []
		array << expected_start_date.strftime("%d %b")
		array << expected_end_date.strftime("%d %b")
	end
	
	#Verificamos si se cambiaron los plazos de la tarea
	def date_changed?
		expected_start_date_changed? or expected_end_date_changed? or duration_changed?
	end

	# devuelve la tarea padre o el proyecto si es que es tarea de primer nivel
	def project_or_parent
		parent || project
	end

	# progreso como float
	def progress_f
		progress.to_f/100
	end

	# fecha esperada de inicio como string
	def expected_start_date_s
		if expected_start_date 
			expected_start_date.strftime("%d-%m-%Y")
		end
	end

	# fecha esperada de fin como string
	def expected_end_date_s
		if expected_end_date 
			expected_end_date.strftime("%d-%m-%Y")
		end
	end
	
	def class_urgente
		if self.urgent
			return 'urgente'
		else
			return 'no_urgente'
		end
	end

	# boolean si la tarea esta atrasada
	def delayed
		if progress < expected_progress
			return true
		end

		return false
	end

	# boolean si la tarea está terminada o no
	def done
		self.progress == 100
	end

	# boolean si la tarea se ecuentra en progreso
	def in_progress
		self.info_progress[0] > 0 && self.info_progress[0] < 100
	end

	# días que quedan desde hoy hasta la fecha esperada de término
	def remaining
		(self.expected_end_date - Time.now)/(60 * 60 * 24).to_i
	end

	

	# def duration
	# 	if !has_children?
	#  		if expected_start_date == expected_end_date
	#  			self.duration = 1
	#  		else
	#  			self.duration = ((expected_end_date - expected_start_date)/ (24 * 60 * 60))
	#  		end
	#  	else
	#  		self.duration = 0
	#  		children.each do |c|
	#  			self.duration += c.duration
	#  		end
	# 	end

	# 	self.sneaky_save
	# end

	def duration_in_date
		if expected_start_date and expected_end_date
	 		if expected_start_date == expected_end_date
	 			return 1
	 		else
	 			((expected_end_date - expected_start_date)/ (24 * 60 * 60))
	 		end
		else
			duration
		end

	end

	# entrega las tareas hermanas de una tarea (las hijas de su padre)
	def brothers
		aux = []
		self.parent.children.each do |c|
			aux << c unless c == self
		end
		aux
	end

	def has_children?
		children.size > 0
	end

	# primera fecha de inicio de hijos
	def children_start
		project_or_parent.children.sort_by{|t| t[:expected_start_date]}.first.try(:expected_start_date)
	end

	# ultima fecha de termino de hijos
	def children_end
		project_or_parent.children.sort_by{|t| t[:expected_end_date]}.last.try(:expected_end_date)
	end

	#último reporte antes de la fecha solicitada
	def last_report_before(date)
		reports.before(date).last
	end

	# días desde que la tarea empezó hasta la fecha
	# si no ha empezado es 0 y si ya terminó es la duración de la tarea
	def days_from_start(date)
		if date < expected_start_date
			0
		elsif date > expected_end_date
			duration
		else
			(expected_start_date.to_date..date.to_date-1).select {|d| (1..5).include?(d.wday) }.size
		end
	end

	# Calcula la duración en días en base a fecha de inicio y de fin, contando solo días laborales
	# Si empieza y termina el mismo día devuelve 0
	def full_duration
		d = (expected_start_date.to_date..expected_end_date.to_date).select {|d| (1..5).include?(d.wday) }.size
		d != 0 ? d : 1
	end

	# metodo que devuelve el nombre de la tarea padre
	def parent_name
		if self.parent
			parent.try(:name)
		else
			self.project.name
		end
	end

	def real_progress_as_percentage
		"#{progress.round}"
	end

	def expected_progress_as_percentage
		"#{progress_esperado.round}"
	end

	# metodo que devuelve el nombre del usuario responsable
	def user_name
		user.try(:name)
	end


	# devuelve un arreglo con todas las tareas que estan debajo
	def tasks_below_count
		count = 0
		children.each do |c|
			count += 1
			count += c.tasks_below_count
		end
		count
	end

	#Si una tarea padre tiene un responsable, toda su descendencia tiene el mismo user.
	def check_parent_user
		if user_id_changed? and has_children?
			children.each do |c|
				c.user = user
				# usamos sneaky save (sin callbacks) para que no se recalculen los avances del proyecto
				c.sneaky_save
				c.check_parent_user
			end
		end
	end


	def destroy_without_callback
		reports.map(&:delete)
		comments.map(&:delete)
		children.each do |c|
			c.destroy_without_callback
		end
		self.delete
	end

	#En base a la duración y la fecha de inicio, se define la fecha de termino.
  	def end_date_task
		return expected_start_date.to_date + (weekdays_duration - 1).days 	
  	end

  	# Devuelve la cantidad de dias que corresponden a considerar la duración en dias habiles
	def weekdays_duration
		p = expected_start_date.strftime("%u").to_i
		d = self.duration
		n = 0

		if p < 6
			if 6 > d + p
				n = 6 - p + 2
			else
				n = 6 - p
			end 
			d = d - 6 + p
		end

		while d != 0
			if d > 4
				n = n + 7
				d = d - 5
			else
				n = n + d
				d = 0
			end
		end     	
    	return n.to_i
  	end

	# helper que entrega el progreso real en dias para una fecha determinada
	def real_days_progress(date)
		real_progress(date, false)
	end

	def real_resources_progress_at(date)
		real_progress(date, true)
	end










# METODOS CON LOGICA SUPERIOR 


	# RECURSOS

		#Se actualiza la cantidad de recursos
		def set_resources
			# if project.resources
			# 	if parent
			# 		#Si el padre es otra tarea actualizamos la fecha de la tarea padre y 
			# 		# luego debiera llamar al mismo método al hacer (:after_update)
			# 		total = parent.resources_total_cost
			# 		if project.resources and total != parent.resources_cost	
			# 			parent.resources_cost = total
			# 			parent.save
			# 		end
			# 	else
			# 		total = project.total_resources_cost
			# 		if project.resources and total != project.resources
			# 			project.resources = total
			# 			project.save	
			# 		end
			# 	end
			# end
		end


		# calcula el progreso real de la tarea en base a costos
		def real_resources_progress_from_task(date)
			e = expected_resources_progress(project.end_date.end_of_day)
			e > 0 ? real_resources_progress(date) / e : 0
		end


		# calcula el progreso real de la tarea en base a costos
		def real_resources_progress(date)
			if has_children?
				children.includes(:children).includes(:project).inject(0.0) do |total, task|
	  				total += task.real_resources_progress(date)
	  			end 
			elsif report = last_report_before(date)
				(report.progress*expected_resources_progress(project.end_date.end_of_day)).to_f
			else
				0
			end
		end





	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 








	# Duracion calculada dinamicamente segun hijos
	def duration
		if !has_children?
			((expected_end_date - expected_start_date)/ (24 * 60 * 60))
		else
			aux = 0
			children.each do |c|
				aux += c.duration
			end

			return aux 
		end

	end

	# reportes que contienen recursos
	def resources_reports
		array = []
		reports.each do |r|
			if r.resources != 0
				array << r
			end
		end

		array
	end


	# Progreso real hoy
	def progress
		if project.resources_type == 0
			real_progress_function(Time.now, false)
		else
			real_progress_function(Time.now, true)
		end
	end

	# Progrso estimado hoy
	def expected_progress
		if project.resources_type == 0
			expected_progress_function(Time.now, false)
		else
			expected_progress_function(Time.now, true)
		end
	end

	# Formula que entrega el avance real segun fecha y unidad especificada
	# date = datetime
	# in_resources = boolean	
	def real_progress_function(date, in_resources)
		if !has_children?
			if reports.count > 0
				if last_report_before(date)
					last_report_before(date).progress
				else
					0
				end
			else
				0
			end
		else
			total_children_value = 0
			total_children_value_extolled = 0

			if !in_resources
				children.each do |c|
					total_children_value += c.duration
					total_children_value_extolled += c.real_progress_function(date, in_resources) * c.duration
				end
			else
				children.each do |c|
					total_children_value += c.resources_cost
					total_children_value_extolled += c.real_progress_function(date, in_resources) * c.resources_cost_from_children
				end
			end

			return (total_children_value_extolled/total_children_value).to_f.round(1)
		end
	end

	# Formula que entrega el avance esperado segun fecha y unidad especificada
	# date = datetime
	# in_resources = boolean
	def expected_progress_function(date, in_resources)
		if !has_children?
			if date > expected_end_date
				100
			elsif  full_duration > 0
				((days_from_start(date).to_f/duration)*100).round(1)
			else
				0
			end
		else
			total_children_value = 0
			total_children_value_extolled = 0

			# si lo piden en tiempo
			if !in_resources
				children.each do |c|
					total_children_value += c.duration
					total_children_value_extolled += c.expected_progress_function(date, in_resources) * c.duration
				end
			# si lo piden en recursos
			else
				children.each do |c|
					total_children_value += c.resources_cost
					total_children_value_extolled += c.expected_progress_function(date, in_resources) * c.resources_cost_from_children
				end
			end


			return (total_children_value_extolled/total_children_value).to_f.round(1)
		end
	end


	# Costo calculado dinamicamente segun los hijos
	def resources_cost_from_children
		if !has_children?
			resources_cost
		else
			suma = 0
			children.each do |c|
				suma += c.resources_cost_from_children
			end

			return suma 
		end
	end

	# reporte rapido
	def fast_report(user_id)
		# Creamos un reporte hecho por el usuario de la sesion
		reports << Report.create(progress: 100, user_id: user_id)
	end
end
