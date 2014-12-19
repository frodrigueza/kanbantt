module UsersHelper

	def roles_array(my_role)
		if my_role == "super_admin"
			[['Super Administrador', 'super_admin'], ['Administrador', 'admin'], ['Last Planner', 'last_planner'], ['Observador', 'observer']] 
		elsif my_role == "admin"
			[['Administrador', 'admin'], ['Last Planner', 'last_planner'], ['Observador', 'observer']] 
		end
	end
end
