class Project < ActiveRecord::Base
	
	#Tiene versionamiento de datos
	has_paper_trail

	has_many :assignments, dependent: :destroy
	has_many :users, through: :assignments

	has_many :tasks, dependent: :destroy

	has_many :comments, dependent: :destroy

	has_many :days_progresses, dependent: :destroy
	has_many :resources_progresses, dependent: :destroy
	has_many :performance_progresses, dependent: :destroy

	#que el nombre este presente al crear/editar el proyecto y tenga largo minimo 3
	validates :name, presence: true, length: { minimum: 3 }
	#validacion para que la fecha de fin sea posterior a la de comienzo
	validates_presence_of :start_date, :end_date
	validate :end_date_is_after_start_date

	# recalcular avances cuando se actualiza (cambia una fecha de una tarea, se agrega una o el)
  	before_destroy :destroy_tasks
	
	# Metodo que inicializa el proyecto al crearse
	def f_create(user)
		user.projects << self
	end

	# devuelve las tareas de primer nivel, es decir que no tienen padres
	def first_tasks
		self.tasks.in_level(1)
	end

	def children
		first_tasks
	end

	def has_children?
		children.count > 0
	end

	# formateo de fechas para mostrarlas de mejor manera en las vistas
	def f_start_date
		self.start_date.strftime("%d / %m / %Y")
	end
	def f_end_date
		self.end_date.strftime("%d / %m / %Y")
	end

	def progress_f
		(dp_days_progress(Date.today)[0]).to_f
	end

	# Avance real en base a tiempo
	def real_days_progress_today
		days_progresses.at(Date.today).first.try(:real) || dp_days_progress_today[0]
	end

	# Avance esperado en base a tiempo
	def estimated_days_progress_today
		days_progresses.at(Date.today).first.try(:expected) || dp_days_progress_today[1]
	end

	def dp_days_progress_today
		@dp_days_progress = @dp_days_progress || dp_days_progress(Date.today)
	end

	# Avance real en base a recursos
	def real_resources_progress_today
		resources_progresses.at(Date.today).first.try(:real) || dp_resources_progress_today[0]
	end

	# Avance esperado en base a recursos
	def estimated_resources_progress_today
		resources_progresses.at(Date.today).first.try(:expected) || dp_resources_progress_today[1]
	end

	def dp_resources_progress_today
		@dp_resources_progress = @dp_resources_progress || dp_resources_progress(Date.today)
	end

	def progress_difference
		real_days_progress_today.round - estimated_days_progress_today.round
	end

	def progress_resources_difference
		real_resources_progress_today.round - estimated_resources_progress_today.round	
	end

	####  Para mostrar avance en base a tiempo   ######
	def progress_as_percentage
		"#{real_days_progress_today.round}%"
	end

	def estimated_progress_as_percentage
		"#{estimated_days_progress_today.round}%"
	end

	def progress_difference_as_percentage
		"#{progress_difference}%"
	end
	############

	####  Para mostrar avance en base a recursos   ######
	def resources_progress_as_percentage
		"#{real_resources_progress_today.round}%"
	end

	def resources_estimated_progress_as_percentage
		"#{estimated_resources_progress_today.round}%"
	end

	def resources_progress_difference_as_percentage
		"#{progress_resources_difference}%"
	end
	############

	#### Para mostrar el avance segun si tiene o no recursos ####
	def info_progress_as_percentaje
		if self.resources
			real = resources_progress_as_percentage
			expected = resources_estimated_progress_as_percentage
		else
			real = progress_as_percentage
			expected = estimated_progress_as_percentage
		end

		return [real, expected]
	end
	###########

	#### Mostrar info de recursos, tipo y reporte ####
	def info_project_resources(data)
		if data
			return 'Si'
		else
			return 'No'
		end
	end
	###########


	# Pide el costo total de la tarea, que se calcula en base a los hijos y lo guarda en el caché
	def total_resources_cost
    	Rails.cache.fetch("#{cache_key}/total_resources_cost") do
      		first_tasks.map(&:resources_total_cost).inject(:+)
    	end
  	end

	#Calculo de avance en días con programación dinámica
	def dp_days_progress(date)
		dp_progress(date, false, false)
	end

	#Calculo de avance en recursos con programación dinámica 
	def dp_resources_progress(date)
		dp_progress(date, true, false)
	end

	#Calculo de desempeño en recursos con programación dinámica
	def dp_performance_progress(date)
		dp_progress(date, true, true)
	end



	#Calculo de avance con programación dinámica
	# in_resources es true si el cálculo es con recursos
	def dp_progress(date, in_resources, report)
		# Hashes con id's de tareas como key y valores de avance real, costo y avance esperado de cada tarea
		real = Hash.new
		cost = Hash.new
		qty = Hash.new
		exp = Hash.new
		tasks.includes(:children).by_level.each do |t|
			if t.has_children? 
				#Si tiene hijos se calculan como la suma de sus hijos (que se sacan del mismo arreglo)
				real[t.id] = t.children.map{|ch| real[ch.id]}.inject(:+)
				cost[t.id] = t.children.map{|ch| cost[ch.id]}.inject(:+)
				exp[t.id] = t.children.map{|ch| exp[ch.id]}.inject(:+)
				qty[t.id] = t.children.map{|ch| qty[ch.id]}.inject(:+)
			else
				#Si no tiene hijos se calculan	
				cost[t.id] = in_resources ? t.resources_cost : t.days_cost
				real[t.id] = (t.last_report_before(date).try(:progress) || 0 )*cost[t.id]/100
				qty[t.id] = (t.last_resources_before(date).try(:resources) || 0 )
				exp[t.id] = t.expected_days_progress(date+1.day)*cost[t.id]
			end
		end
		#Para obtener los del proyecto se suman las primeras tareas
		prog= first_tasks.map{|ch| real[ch.id]}.inject(:+) #Sumo los avances reales de las primeras hijas del proyecto
		cost= first_tasks.map{|ch| cost[ch.id]}.inject(:+)#Sumo el costo de las primeras hijas del proyecto
		exp = first_tasks.map{|ch| exp[ch.id]}.inject(:+) #Sumo los avances esperados de las primeras hijas del proyecto
		qty = first_tasks.map{|ch| qty[ch.id]}.inject(:+) #Sumo las avances reportados en relación a los recursos utilizados.

		if report
			#cantidad de recursos presupuestados a gastar en función de lo que se ha avanzado realmente.
			expected_resources = prog
			real_resources = qty

			return [real_resources.to_i, expected_resources.to_i]

		else
			if cost and cost > 0
				real_progress = prog/cost
				expected_progress = exp/cost
			else
				real_progress = 0
				expected_progress = 0
			end

			return [(100*real_progress).to_f.round(2), (100*expected_progress).to_f.round(2)]
		end
	end

	def cost_total_project(in_resources)
		cost = Hash.new
		tasks.includes(:children).by_level.each do |t|
			if t.has_children? 
				cost[t.id] = t.children.map{|ch| cost[ch.id]}.inject(:+)
			else	
				cost[t.id] = in_resources ? t.resources_cost : t.days_cost
			end
		end
		costo= first_tasks.map{|ch| cost[ch.id]}.inject(:+)
		return costo
	end

	def performance_expected
		(cost_total_project(true)*real_resources_progress_today/100).to_i
	end

	def performance_difference
		(performance_expected - performance_real).to_i

	end

	def performance_real
		qty = Hash.new
		tasks.includes(:children).by_level.each do |t|
			if t.has_children? 
				
				qty[t.id] = t.children.map{|ch| qty[ch.id]}.inject(:+)
			else
				
				qty[t.id] = (t.last_resources_before(Date.today).try(:resources) || 0 )
			end
		end
		
		qty = (first_tasks.map{|ch| qty[ch.id]}.inject(:+)).to_i
		return qty
	
	end

	#Recibe una fecha esperada de inicio y si es menor a la actual entonces se cambia la fecha de inicio del proyecto
	def update_start_date(expected_start_day)
			self.start_date = expected_start_day
	end

	def update_end_date(expected_end_date)
			self.end_date = expected_end_date
	end

    # Validación
	def end_date_is_after_start_date
	  return if end_date.blank? || start_date.blank?

	  if end_date <= start_date
	    errors.add(:end_date, "La fecha de término debe ser posterior a la de inicio")
	  end 
	end

	# Metodo que asigna una imagen a los proyectos.
	def image(n)
		if n < 5
			return 'p'+n.to_s+'.jpg'
		else
			self.image(n-5)
		end
	end

	# días hábiles desde que el proyecto empezó hasta la fecha
	# si no ha empezado es 0 y si ya terminó es la duración del proyecto
	def days_from_start(date)
		if date < start_date
			0
		elsif date > end_date
			duration
		else
			weekdays_betweeen(start_date,date.to_date-1)
		end
	end

	#Devuelve el retraso en días del proyecto
	def days_of_delay
		real = start_date + ((duration*real_days_progress_today/100).to_i).days
		esperado = start_date + ((duration*estimated_days_progress_today/100).to_i).days
		return weekdays_betweeen(real,esperado)
	end

	def duration
		weekdays_betweeen(start_date,end_date)
	end

	def weekdays_betweeen(start,finish)
		(start.to_date..finish.to_date).select {|d| (1..5).include?(d.wday) }.size
	end

	# Método que se llama cuando se crea un reporte en alguna tarea del proyecto
	# y actualiza el avance a la fecha.
	# def update_progresses
	# 	p "Actualizando progresos proyecto #{name}..."
	# 	pc = ProgressCalculator.new(self)
	# 	d_progress = dp_days_progress(Date.today)
	# 	pc.create_or_update_days_progress(d_progress[0], d_progress[1], Date.today)
	# 	r_progress = dp_resources_progress(Date.today)
	# 	pc.create_or_update_resources_progress(r_progress[0], r_progress[1], Date.today)
	# 	p_progress = dp_performance_progress(Date.today)
	# 	pc.create_or_update_performance_progress(p_progress[0], p_progress[1], Date.today)
	# end

	# # Método para limpiar avances guardados del proyecto y calcularlos de nuevo
	# def calculate_progresses
	# 	p "Calculando progresos proyecto #{name}..."
	# 	days_progresses.destroy_all
	# 	pc = ProgressCalculator.new(self)
	# 	pc.days_progress
	# 	resources_progresses.destroy_all
	# 	pc.resources_progress
	# 	performance_progresses.destroy_all
	# 	pc.performance_progress
	# end
	# handle_asynchronously :calculate_progresses

	########################### KANBAN
	def kanban_inactive_tasks
		array = []
		tasks.each do |t|
			if !t.has_children? && t.progress == 0
				array << t
			end
		end
		array
	end
	
	def kanban_in_progress_tasks
		array = []
		tasks.each do |t|
			progress_aux = t.progress
			if !t.has_children? && progress_aux != 0 && progress_aux !=100
				array << t
			end
		end
		array
	end
	def kanban_done_tasks
		array = []
		tasks.each do |t|
			if !t.has_children? && t.progress == 100
				array << t
			end
		end
		array
	end

	########################### FIN KANBAN

	# Metodo que actualiza el progreso del proyecto segun los progresos de sus hijos de primer nivel
	def update_progress_from_children
		if has_children?
			# duracion (o recursos) de los hijos ponderados por sus progresos
			total_children_value_extolled = 0
			self.children.each do |c|
				child_value = 0
				if resources
					child_value = c.resources_cost
				else
					child_value = c.duration
				end
				total_children_value_extolled += c.progress * child_value
			end

			# vemos cuanto es la duracion (o recursos) total de los hijos
			total_children_value = 0
			self.children.each do |c|
				if resources
					total_children_value += c.resources_cost ? c.resources_cost : 0.0
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
	end


	# Metodo que actualiza los recursos del proyecto segun sus hijos
	def update_resources_and_duration_from_children
		if resources
			if has_children?
				# recursos de los hijos
				total_children_resources = 0
				self.children.each do |c|
					total_children_resources += c.resources
				end

				# Actualizamos el costo total del proyecto
				cost = total_children_resources
			end
		end
	end

	# actualizamos las fechas de inicio y termino esperado segun las fechas de lo hijos
	def update_dates_from_children
		if has_children?
			# Tomamos la primera fecha de inicio de los hijos como la fecha de inicio del padre
			expected_start_date = (children.sort_by &:expected_start_date).first.expected_start_date
			# Tomamos la ultima fecha de termino de los hijos como la fecha de termino del padre
			expected_end_date = (children.sort_by &:expected_end_date).last.expected_end_date
		end
	end

	private

	def destroy_tasks
		children.each do |c|
			c.destroy_without_callback
		end
	end



end
