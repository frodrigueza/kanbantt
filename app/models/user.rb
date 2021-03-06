class User < ActiveRecord::Base
	# pertenece a una empresa
	belongs_to :enterprise

	# es dueño de maximo una empresa
	has_one :owned_enterprise, class_name:'Enterprise', foreign_key:'boss_id'

	#relación con proyectos
	has_many :assignments, dependent: :destroy
	has_many :projects, through: :assignments
	#puede tener muchas tareas
	has_many :tasks
	has_many :reports
	#tiene una api key, esta key debe eliminarse si el usuario es destruido
	has_many :api_key, dependent: :destroy 

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
	ROLES = %i[super_admin admin last_planner observer]

	def f_name
		name + ' ' + last_name
	end

	def is_boss
		if self.super_admin
			false
		elsif self.enterprise.boss == self
			true
		else
			false
		end
	end

	def role_in_project(project)
		if !is_boss && !super_admin
			role = Assignment.where(user_id: id, project_id: project.id).first.role
			if role == 1
				return 'Administrador'
			elsif role == 2
				return 'Last planner'
			end
		else
			return 'Jefe'
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
	def kanban(project)
		tasks_hash = {}
		inactive_tasks = []
		in_progress_tasks = []
		done_tasks = []

		project.kanban[:inactive_tasks].each do |t|
			if role_in_project(project) == 'Administrador' || is_boss
				inactive_tasks << t
			elsif role_in_project(project) == 'Last planner' && t.user_id == id
				inactive_tasks << t
			end
		end

		project.kanban[:in_progress_tasks].each do |t|
			if role_in_project(project) == 'Administrador' || is_boss
				in_progress_tasks << t
			elsif role_in_project(project) == 'Last planner' && t.user_id == id
				in_progress_tasks << t
			end
		end

		project.kanban[:done_tasks].each do |t|
			if role_in_project(project) == 'Administrador' || is_boss
				done_tasks << t
			elsif role_in_project(project) == 'Last planner' && t.user_id == id
				done_tasks << t
			end
		end

		tasks_hash[:inactive_tasks] = inactive_tasks
		tasks_hash[:in_progress_tasks] = in_progress_tasks
		tasks_hash[:done_tasks] = done_tasks

		return tasks_hash
	end

	######################## FIN KANBAN

	# PERMISOS
	def can_edit_task(task)
		if super_admin
			return true
		elsif is_boss && task.enterprise == enterprise 
			return true
		elsif a = Assignment.where(user_id: id, project_id: task.project.id).first
			if a.role == 1
				return true
			end
		else
			return false
		end
	end

	def can_report_task(task)
		if super_admin
			true
		elsif a = Assignment.where(user_id: id, project_id: task.project.id).first
			# El admin puede reportar cualquier tarea
			if a.role == 1
				return true

			# El lastplanner puede reportar solo sus propias tareas
			elsif task.user == self
				return true
			end
		else
			return false
		end
	end

	def can_edit_project(project)
		if super_admin
			return true
		elsif is_boss && project.enterprise == enterprise 
			return true
		elsif a = Assignment.where(user_id: id, project_id: project.id).first
			if a.role == 1
				return true
			end
		else
			return false
		end
	end

end