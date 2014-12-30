class Report < ActiveRecord::Base
	#Pertenece a una tarea
	belongs_to :task
	belongs_to :user
	scope :week_of, ->(date) {where(created_at: date.all_week) }
	scope :before, ->(date) {where('created_at <= ?',date.end_of_day)}
	default_scope { order(created_at: :asc) }

	def project
		task.project
	end

	def user_f_name
		if user
			user.f_name
		else
			'Importacion'
		end
	end

	private
end
