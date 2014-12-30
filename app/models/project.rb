class Project < ActiveRecord::Base
	
	#Tiene versionamiento de datos
	has_paper_trail

	has_many :assignments, dependent: :destroy
	has_many :users, through: :assignments

	has_many :tasks, dependent: :destroy

	has_many :comments, dependent: :destroy

	has_many :indicators, dependent: :destroy

	belongs_to :enterprise

	#que el nombre este presente al crear/editar el proyecto y tenga largo minimo 3
	validates :name, presence: true, length: { minimum: 3 }
	#validacion para que la fecha de fin sea posterior a la de comienzo
	validates_presence_of :expected_start_date, :expected_end_date
	validate :expected_end_date_is_after_expected_start_date

	# recalcular avances cuando se actualiza (cambia una fecha de una tarea, se agrega una o el)
  	before_destroy :destroy_tasks
	
	# Metodo que inicializa el proyecto al crearse
	def f_create(user)
		user.projects << self
	end

	def f_resources_type
		if resources_type == 0
			return ''
		elsif resources_type == 1
			return 'USD'
		elsif resources_type == 2
			return 'UF'
		elsif resources_type == 3
			return 'HH'
		end
	end

	def children
		tasks.where(parent_id: nil)
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
				qty[t.id] = (t.last_report_before(date).try(:resources) || 0 )
				exp[t.id] = t.expected_days_progress(date+1.day)*cost[t.id]
			end
		end
		#Para obtener los del proyecto se suman las primeras tareas
		prog = children.map{|ch| real[ch.id]}.inject(:+) #Sumo los avances reales de las primeras hijas del proyecto
		cost = children.map{|ch| cost[ch.id]}.inject(:+)#Sumo el costo de las primeras hijas del proyecto
		exp = children.map{|ch| exp[ch.id]}.inject(:+) #Sumo los avances esperados de las primeras hijas del proyecto
		qty = children.map{|ch| qty[ch.id]}.inject(:+) #Sumo las avances reportados en relación a los recursos utilizados.

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
				
				qty[t.id] = (t.last_report_before(Date.today).try(:resources) || 0 )
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
	def expected_end_date_is_after_expected_start_date
	  return if expected_end_date.blank? || expected_start_date.blank?

	  if expected_end_date <= expected_start_date
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
		if date < expected_start_date
			0
		elsif date > expected_end_date
			duration
		else
			weekdays_betweeen(expected_start_date,date.to_date-1)
		end
	end

	#Devuelve el retraso en días del proyecto
	def days_of_delay
		real = start_date + ((duration*real_days_progress_today/100).to_i).days
		esperado = start_date + ((duration*estimated_days_progress_today/100).to_i).days
		return weekdays_betweeen(real,esperado)
	end

	def duration
		weekdays_betweeen(expected_start_date, expected_end_date)
	end

	def weekdays_betweeen(start,finish)
		(start.to_date..finish.to_date).select {|d| (1..5).include?(d.wday) }.size
	end

	# # Método que se llama cuando se crea un reporte en alguna tarea del proyecto
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
	def calculate_progresses
		p "Calculando progresos proyecto #{name}..."
		days_progresses.destroy_all
		pc = ProgressCalculator.new(self)
		pc.days_progress
		# resources_progresses.destroy_all
		# pc.resources_progress
		# performance_progresses.destroy_all
		# pc.performance_progress
	end
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

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 



	# Progreso real hoy
	def progress
		if resources_type == 0
			real_progress_function(Time.now, false)
		else
			real_progress_function(Time.now, true)
		end
	end

	# Progrso estimado hoy
	def expected_progress
		if resources_type == 0
			expected_progress_function(Time.now, false)
		else
			expected_progress_function(Time.now, true)
		end
	end

	# Formula que entrega el avance real segun fecha y unidad especificada
	# date = datetime
	# in_resources = boolean	
	def real_progress_function(date, in_resources)
		if date < Time.now
			if !has_children?
				if reports.count > 0
					last_report_before(date).progress
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
		else
			return nil
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

	def reports
		array = []
		tasks.each do |t|
			t.reports.each do |r|
				array << r
			end
		end 

		array.sort_by{ |report| report.created_at }
	end

	def last_report
		reports.last
	end

	def full_duration
		d = (expected_start_date.to_date..expected_end_date.to_date).select {|d| (1..5).include?(d.wday) }.size
		d != 0 ? d : 1
	end

	def f_resources_type
		case resources_type
			when 0
			  return "Tiempo"
			when 1
			  return "USD"
			when 2
			  return "UF"
			when 3
			  return "H/H"
		end
	end

	def last_planners
		array = []
		self.assignments.each do |a|
			if a.role == 2
				array << a.user
			end
		end

		array.sort_by { |user| user.last_name }
	end

	private

	def destroy_tasks
		children.each do |c|
			c.destroy_without_callback
		end
	end

end
