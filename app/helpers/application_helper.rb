module ApplicationHelper

	# devuelve una clase que se usa en tree view
	# esta clase se aplicará a todas las columnas menos la primera para hacer un fadeIn en Jquery.
	def column_class(parent)
		if parent.class.name == "Task"
			return 'task_column'
		else
			return 'project_column'
		end
	end

	def f_date(date)
		if date
			date.strftime("%d %b %Y")
		else
			''
		end
	end
end
