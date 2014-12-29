class ProgressCalculator

	def initialize(project)
		@project = project
	end

	def create_indicators
		project_dates_to_end.each do |date|

			indicator = Indicator.new(project_id: @project.id, date: date)
			indicator.real_days_progress = @project.real_progress_function(date, false)
			indicator.expected_days_progress = @project.expected_progress_function(date, false)

			if @project.resources_type != 0
				indicator.real_resources_progress = @project.real_progress_function(date, true)
				indicator.expected_resources_progress = @project.expected_progress_function(date, true)
			end

			indicator.save
		end

		a.a
	end


	################ Metodos para cálculos de avance en base a recursos ########################

# 	# Obtiene el avance esperado en recursos o lo calcula si no lo ha hecho
# 	def expected_in_resources
#  		@rp = @rp || resources_progress
#  		@rp[1]
# 	end

# 	# Obtiene el avance real en recursos o lo calcula si no lo ha hecho
# 	def real_in_resources
#  		@rp = @rp || resources_progress
#  		@rp[0]
# 	end

# 	# Metodo que usa programacion dinamica para encontrar avance real y esperado en recursos para cada semana
# 	def resources_progress
# 		progress(true, false)
# 	end

# 	#Guardo los avances para esa fecha
# 	def create_or_update_resources_progress(real_progress, expected_progress, date)
# 		resources_progress = @project.resources_progresses.at(date).first || ResourcesProgress.new(date:date)
# 		resources_progress.update_attributes(real:real_progress, expected:expected_progress)
# 		@project.resources_progresses << resources_progress
# 	end

# 	################ Metodos para cálculos de desempeño de recursos ########################

# 	# Obtiene el avance esperado en dias o lo calcula si no lo ha hecho
# 	def expected_in_report
#  		@pp = @pp || performance_progress
#  		@pp[1]
# 	end

# 	# Obtiene el avance real en dias o lo calcula si no lo ha hecho
# 	def real_in_report
#  		@pp = @pp || performance_progress
#  		@pp[0]
# 	end

# 	def performance_progress
# 		progress(true, true)
# 	end

# 	#Guardo los avances para esa fecha
# 	def create_or_update_performance_progress(real_progress, expected_progress, date)
# 		performance_progress = @project.performance_progresses.at(date).first || PerformanceProgress.new(date:date)
# 		performance_progress.update_attributes(real:real_progress, expected:expected_progress)
# 		@project.performance_progresses << performance_progress
# 	end


# 	################ Metodos para cálculos de avance en base a tiempo ########################


# 	# Obtiene el avance esperado en dias o lo calcula si no lo ha hecho
# 	def expected_in_days
#  		@dp = @dp || days_progress
#  		@dp[1]
# 	end

# 	# Obtiene el avance real en dias o lo calcula si no lo ha hecho
# 	def real_in_days
#  		@dp = @dp || days_progress
#  		@dp[0]
# 	end

# 	# Metodo que usa programacion dinamica para encontrar avance real y esperado en días para cada semana
# 	def days_progress
# 		progress(false, false)
# 	end

# 	#Guardo los avances para esa fecha
# 	def create_or_update_days_progress(real_progress, expected_progress, date)
# 		days_progress = @project.days_progresses.at(date).first || DaysProgress.new(date:date)
# 		days_progress.update_attributes(real:real_progress, expected:expected_progress)
# 		@project.days_progresses << days_progress
# 	end

	

# 	# Metodo que usa programacion dinamica para encontrar avance real y esperado en días para cada semana
# 	def progress(in_resources, report)
# 		real_arr = []
# 		exp_arr = []
#  		project_dates_to_end.each do |date|
#  			# si ya existe el dato, lo saco de la tabla, si no existe se calcula y se guarda en la tabla
#  			# si el cálculo es con recursos
#  			if in_resources && !report
# 	 			if progress = @project.resources_progresses.at(date).first
# 	 				pr = [progress.real, progress.expected]
# 	 			else
# 		 			pr = @project.dp_resources_progress(date)			
# 		 			create_or_update_resources_progress(pr[0],pr[1],date)
# 		 		end

# 		 	#Si los recursos se reportan
# 		 	elsif in_resources && report
# 		 		if progress = @project.performance_progresses.at(date).first
# 	 				pr = [progress.real, progress.expected]
# 	 			else
# 		 			pr = @project.dp_performance_progress(date)			
# 		 			create_or_update_performance_progress(pr[0],pr[1],date)
# 		 		end

		 		
# 		 	# y si el cálculo es con tiempo
# 		 	else			
# 		 		create_or_update_days_progress(@project.real_progress_function(date, false),@project.expected_progress_function(date, false),date)
# 		 	end
# ### 			# Desde el inicio del proyecto a la fecha actual se obtiene avance real
# 			if date <= Date.today
#  				real_arr << [date,pr[0]]
#  			end
# 			# Desde el inicio del proyecto al fin se obtiene avance esperado
#  			if in_resources && report
#  				if date <= Date.today
#  					exp_arr << [date,pr[1]]
#  				end
#  			else 
#  				exp_arr << [date,pr[1]]
#  			end
#  		end
#  		[real_arr,exp_arr]
# 	end

# 	################ Metodos para cálculos de fechas de proyecto ########################

	def project_dates_to_end
		if Date.today > @project.expected_end_date.to_date
			project_dates(Date.today)
		else
			project_dates(@project.expected_end_date.to_date)
		end
	end

	def project_dates_to_today
		project_dates(Date.today)
	end


	def project_dates(end_date)
		# Si el proyecto dura menos de un mes, se obtienen indicadores por día
		if (@project.expected_end_date.to_date - @project.expected_start_date.to_date).to_i <= 30 
			my_days =  [1,2,3,4,5,6,0] # day of the week in 0-6. Sunday is day-of-week 0; Saturday is day-of-week 6.
			new_start_date = @project.expected_start_date.to_date
		# Si no, se obtienen por semana y se agregan días al final para llegar al lunes siguiente de la fecha de fin con 100%
		else 
			my_days = [1]
			new_start_date = @project.expected_start_date.beginning_of_week.to_date
		end
		# Si la fecha fin de proyecto ya pasó, solo se obtienen hasta esa fecha
		# if Date.today > @project.end_date.to_date
		# 	end_date = @project.end_date.to_date
		# end
		# obtiene todas las fechas de días lunes entre el inicio y el fin del proyecto, incluyendo la fecha actual
 		array = (new_start_date..end_date.to_date).to_a.select {|k| my_days.include?(k.wday) or k == Date.today}
 		if end_date.monday? or end_date == Date.today
 			array
 		else
 			array << end_date
		end
	end
	
# 	################ Metodos para los gráficos de tareas ########################
# 	# Deshabilitados porque no se implementó


# 	# #Este metodo es para obtener las fechas en tomaremos muestras para el gráfico
# 	# def task_dates_to_end
# 	# 	task.expected_dates(@task.expected_end_date.to_date)
# 	# end

# 	# def task_dates_to_today
# 	# 	task_dates(Date.today)
# 	# end

# 	# def task_dates(end_date)
# 	# 	start_date = @task.expected_start_date.to_date
# 	# 	my_days =  (end_date.to_date - start_date).to_i < 30 ? [1,2,3,4,5] :[1]
#  # 		(start_date..end_date).to_a.select {|k| my_days.include?(k.wday)}
# 	# end

# 	# # Encuentra para cada semana del proyecto el avance estimado semanal en base a tiempo
# 	# def expected_task_in_days(task)
#  # 		arr = []
#  # 		arr << [@project.start_date.to_date.beginning_of_week,0]
#  # 		project_dates_to_end.each do |date|
#  # 			value = (100*@project.expected_days_progress(date.to_date)).to_f.round(2)
#  # 			arr << [date,value]
#  # 		end
#  # 		arr
# 	# end

# 	# # Encuentra para cada día el avance real de la tarea
# 	# def real_task_in_days(task)
# 	# 	arr = []
# 	# 	arr << [@project.start_date.to_date.beginning_of_week,0]
#  # 		project_dates_to_today.each do |date|
#  # 			value = (100*@project.real_days_progress(date.to_date))
#  # 			arr << [date,value.to_f.round(2)]
#  # 		end
#  # 		arr << [Date.today,@project.real_days_progress_today] unless Date.today.monday?
#  # 		arr
# 	# end

# 	# ################# Término métdos para gráficos de tareas #####################

# 	def progress_by_task
# 		arr = []
# 		@project.tasks.each do |t|
# 			exp = (100*t.expected_days_progress(Date.today)).to_f.round(2)
# 			real = (100*t.real_days_progress(Date.today)).to_f.round(2)
# 			arr << [t.id,exp.to_s,real.to_s]
# 		end
#  		arr
# 	end

# 	# #Para los gráficos de cada tarea definimos los siguientes métodos
# 	# def expected_task_in_resources(task)
# 	# 	arr = []
#  # 		arr << [task.start_date.to_date,0]
#  # 		project_dates_to_end.each do |date|
#  # 			value = (100*@project.expected_resources_progress_from_task(date.to_date)).to_f.round(2)
#  # 			arr << [date,value]
#  # 		end
#  # 		arr
# 	# end

# 	# # Encuentra para cada semana del proyecto el avance real semanal en base a recursos
# 	# def real_task_in_resources(task)
# 	# 	arr = []
#  # 		arr << [@project.start_date.to_date.beginning_of_week,0]
#  # 		project_dates_to_today.each do |date|
#  # 			value = (100*@project.real_resources_progress(date.to_date)).to_f.round(2)
#  # 			arr << [date,value]
#  # 		end
#  # 		arr << [Date.today,@project.real_resources_progress_today] unless Date.today.monday?
#  # 		arr
# 	# end


	
end

	