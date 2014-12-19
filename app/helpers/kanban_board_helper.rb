module KanbanBoardHelper
	def time_filter_options
		array = ['Hoy', 'Una semana', '15 días', '1 mes', 'Todos']
	end
	def status_filter_options
		array = ['Comienzan en', 'Terminan en', 'Atrasadas', 'Todos']
	end

	def image_kanban(user)
		if user
			user.image(user.id)
		else
			'white.jpg'
		end
	end
end
