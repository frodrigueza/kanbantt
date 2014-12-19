class User < ActiveRecord::Base

	#relación con proyectos
	has_many :project_users
	has_many :projects, through: :project_users
	#puede tener muchas tareas
	has_many :tasks
	has_many :reports
	#tiene una api key, esta key debe eliminarse si el usuario es destruido
	has_many :api_key, dependent: :destroy 
	#Tiene muchos reportes de recursos
	has_many :resources_reports

	# Que el nombre este presente al crear/editar el usuario y tenga largo minimo 2
	validates :name, presence: true, length: { minimum: 2 }
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
	ROLES = %i[super_admin admin last_planner observer]

	def role_u
		if self.role == 'super_admin'
			return 'Super Administrador'
		elsif self.role == 'admin'
			return 'Administrador'
		elsif self.role == 'last_planner'
			return 'Last Planner'
		else
			return 'Observador'
		end
	end

	def lp?
		if self.role == 'last_planner'
			return true
		else
			return false
		end
	end

	def tasks_by_project(project_id)
		self.tasks.where(project_id: project_id)
	end


	# Retorna true si el usuario esta asignado a algun proyecto del current user
	def show_user(cuser)
		cuser.projects.each do |cup|
			if self.projects.to_a.empty? && !cuser.lp?
				return true
			else
				self.projects.each do |up|
					if up.id == cup.id
						return true
					end
				end
			end
		end
		return false
	end

	def asignar(cuser)
		if cuser.role == 'super_admin'
			return true
		elsif cuser.lp? or cuser.role == 'observer'
			return false
		else
			if self.role == 'super_admin'
				return false
			else
				return true
			end
		end		
	end

	# Metodo que asigna una imagen a los usuarios.
	def image(n)
		if n < 7
			return 'u'+n.to_s+'.jpg'
		else
			self.image(n-7)
		end
	end

	########################### KANBAN
	def kanban_inactive_tasks
		array = []

		# El administrador ve todas las tareas de todos los proyectos
		if role == "admin"
			projects.each do |p|
				p.kanban_inactive_tasks.each do |t|
					array << t
				end 
			end

		# El last_planner solo ve las asignadas a él
		elsif role == "last_planner"
			tasks.each do |t|
				if !t.has_children? && t.progress == 0
					array << t
				end
			end
		end

		return array
	end
	def kanban_in_progress_tasks
		array = []

		# El administrador ve todas las tareas de todos los proyectos
		if role == "admin"
			projects.each do |p|
				p.kanban_in_progress_tasks.each do |t|
					array << t
				end 
			end

		# El last_planner solo ve las asignadas a él
		elsif role == "last_planner"
			tasks.each do |t|
				progress_aux = t.progress
				if !t.has_children? && progress_aux != 0 && progress_aux !=100
					array << t
				end
			end
		end

		return array
	end

	def kanban_done_tasks
		array = []

		# El administrador ve todas las tareas de todos los proyectos
		if role == "admin"
			projects.each do |p|
				p.kanban_done_tasks.each do |t|
					array << t
				end 
			end

		# El last_planner solo ve las asignadas a él
		elsif role == "last_planner"
			tasks.each do |t|
				progress_aux = t.progress
				if !t.has_children? && progress_aux == 100
					array << t
				end
			end
		end

		return array
	end

	######################## FIN KANBAN

end