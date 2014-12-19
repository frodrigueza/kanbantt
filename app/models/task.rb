class Task < ActiveRecord::Base
  require 'gcm'
  require 'json'
  require 'thread'
  	#Tiene versionamiento de datos
	has_paper_trail
	@@sending = false

	#Una tarea puede tener muchos hijos, y cada tarea tiene a lo más un padre.
	has_many :children, foreign_key: 'parent_id', class_name: 'Task'
	belongs_to :parent, class_name: 'Task', counter_cache: 'children_count', touch: true

	#Una tarea tiene muchos reportes
	has_many :reports#, dependent: :destroy

	#Una tarea tiene un dueño
	belongs_to :user

	#Una tarea pertenece a un proyecto
	belongs_to :project

	#Tiene muchos comentarios
	has_many :comments

	#Tiene muchos reportes de recursos
	has_many :resources_reports

	#Tiene una posicion dentro de un kanban
	has_one :task_position, dependent: :destroy
	has_one :column, through: :task_position
	after_commit :call_update, on: [:create, :update, :destroy]

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

	before_create :set_level, :set_duration_from_dates

	# Si cambio el responsable, que toda la descendencia quede con ese responsable	
	after_save :check_parent_user

	# cada vez que se modifica o elimina una task, actualizamos todo el arbol sobre ella. #######################
	after_save :update_tree_over_me
	before_destroy :leave_the_world_in_order

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
		if info_progress[0] < info_progress[1]
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

	def set_duration_from_dates
 		if expected_start_date == expected_end_date
 			duration = 1
 		else
 			duration = ((expected_end_date - expected_start_date)/ (24 * 60 * 60))
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

	#último reporte  de recursos antes de la fecha solicitada
	def last_resources_report_before(date)
		resources_reports.before(date).last
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
			end
		end
	end


	def destroy_without_callback
		reports.map(&:delete)
		comments.map(&:delete)
		task_position.delete if task_position
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

		# calcula el progreso estimado de la tarea en base a costos como un % del total
		# si está lista devuelve el ponderador de la tarea con respecto al proyecto
		def expected_resources_progress(date)
			total = project.cost_total_project(true)
			if total > 0 and full_duration > 0
				(days_from_start(date)/full_duration)/total
			else
				0
			end
		end
		# calcula el progreso estimado de la tarea en base a costos
		def expected_resources_progress_from_task(date)
			expected_resources_progress(date)/expected_resources_progress(project.end_date.end_of_day)
		end

		def expected_resources_at(date)
			if has_children?
				children.map{|ch| ch.expected_resources_at(date)}.inject(:+) 			
			else
				expected_days_progress(date+1.day)*resources_cost
			end
		end
		
		def expected_resources_progress_at(date)
			if resources_cost > 0
				expected_resources_at(date)/resources_cost
			elsif date > expected_end_date
				1
			else
				0
			end
		end

		# actualizamos todos los recursos arriba de esta task
		def update_resources_and_duration_over_me
			# (3) si nos encontramos con una tarea
			if parent					
				# (1) primero hacemos que el padre actualize su progreso segun sus hijos (mis hermanos)
				parent.update_resources_and_duration_from_children

				# (2) y luego que haga lo mismo con su padre y así hasta llegar al projecto
				parent.update_resources_and_duration_over_me
			else
				# (4) como nos encontramos en una tarea de primer nivel, el que tiene que actualizar su progreso es el proyecto.
				project.update_resources_and_duration_from_children
			end
		end

		# Metodo que actualiza los recursos de la tarea segun sus hijos
		def update_resources_and_duration_from_children
			if has_children?
				# costo recursos de los hijos
				total_children_resources_cost = 0
				# recursos utilizados hasta ahora por los hijos
				total_children_resources = 0
				# duracion total de los hijos
				total_children_duration = 0

				self.children.each do |c|
					total_children_resources_cost += c.resources_cost ? c.resources_cost : 0.0
					total_children_resources += c.resources ? c.resources : 0.0
					total_children_duration += c.duration
				end
				resources_cost = total_children_resources_cost
				resources = total_children_resources
				duration = total_children_duration
			else
				set_duration_from_dates
			end
		end









	# TIEMPO

		# Actualiza las fechas de todas las tareas después de un cambio en una tarea sin hijos
		# Debe funcionar después de hacer el update (:after_update) de la fecha de un task, ya que así expected_start_date será el 
		#nuevo que se entrego.	


		# calcula el progreso estimado de la tarea en base a dias
		def expected_days_progress(date)
			if date > expected_end_date
				1
			elsif  full_duration > 0
				days_from_start(date).to_f/full_duration
			else
				0
			end
		end



		# calcula el progreso estimado de la tarea en base a días
		def expected_days_progress_from_task(date)
			expected_days_progress(date)/expected_days_progress(project.end_date.end_of_day)
		end


		# Entrega el real y el esperado actual
		def info_progress
			if self.project.resources
				real = progress.to_f.round
				expected = (100*expected_resources_progress_at(Date.today)).to_f.round
			else
				real = progress.to_f.round
				expected = (100*expected_days_progress(Date.today)).to_f.round
			end
			return [real, expected]
		end


		# calcula el costo de la tarea en base a dias
		def days_cost
			if has_children?
				children.map(&:days_cost).inject(:+)
			else
				duration
			end
		end 




		def progress_esperado
			Rails.cache.fetch("#{cache_key}/progress_esperado/#{Date.today}") do
				(100*expected_days_progress(Date.today)).to_f.round
			end
		end

		# actualizamos todos los progresos arriba de esta task
		def update_progress_over_me
			# (3) si nos encontramos con una tarea
			if parent					
				# (1) primero hacemos que el padre actualize su progreso segun sus hijos (mis hermanos)
				parent.update_progress_from_children

				# (2) y luego que haga lo mismo con su padre y así hasta llegar al projecto
				parent.update_progress_over_me
			else
				# (4) como nos encontramos en una tarea de primer nivel, el que tiene que actualizar su progreso es el proyecto.
				project.update_progress_from_children
			end

		end

		# Metodo que actualiza el progreso de la tarea segun los progresos de sus hijos
		def update_progress_from_children
			# duracion (o recursos) de los hijos ponderados por sus progresos
			total_children_value_extolled = 0
			self.children.each do |c|
				child_value = 0
				if project.resources
					child_value = c.resources_cost
				else
					child_value = c.duration
				end
				total_children_value_extolled += c.progress * child_value
			end

			# vemos cuanto es la duracion (o recursos) total de los hijos
			total_children_value = 0
			self.children.each do |c|
				if project.resources
					total_children_value += c.resources_cost
				else
					total_children_value += c.duration
				end
			end

			# dividimos el ponderado por el total, y sacamos el progreso real
			if total_children_value > 0
				self.progress = (total_children_value_extolled.to_f / total_children_value.to_f).to_f
			else
				self.progress = 0
			end
			self.save
		end

		# actualizamos todos las fechas arriba de esta task
		def update_dates_over_me
			# (3) si nos encontramos con una tarea
			if parent					
				# (1) primero hacemos que el padre actualize sus fechas segun sus hijos (mis hermanos)
				parent.update_dates_from_children

				# (2) y luego que haga lo mismo con su padre y así hasta llegar al projecto
				parent.update_dates_over_me
			else
				# (4) como nos encontramos en una tarea de primer nivel, el que tiene que actualizar su progreso es el proyecto.
				project.update_dates_from_children
			end

		end

		# actualizamos las fechas de inicio y termino esperado segun las fechas de lo hijos
		def update_dates_from_children
			if has_children?
				# Tomamos la primera fecha de inicio de los hijos como la fecha de inicio del padre
				self.expected_start_date = (children.sort_by &:expected_start_date).first.expected_start_date
				# Tomamos la ultima fecha de termino de los hijos como la fecha de termino del padre
				self.expected_end_date = (children.sort_by &:expected_end_date).last.expected_end_date
				self.save
			end
		end
			

		# antes de eliminar una task, se le baja la duracion a cero, su progreso a cero 
		# (se le hace practicamente invisible en los calculos) y se actualiza el arbol sobre el
		def leave_the_world_in_order
			progress = 0
			duration = 0
			resources = 0
			resources_cost = 0
			expected_start_date = nil
			expected_end_date = nil
			update_resources_and_duration_over_me
			update_dates_over_me
			update_progress_over_me
		end

		def update_tree_over_me
			update_resources_and_duration_over_me
			update_dates_over_me
			update_progress_over_me
		end
end
