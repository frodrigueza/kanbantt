class Report < ActiveRecord::Base
	#Pertenece a una tarea
	belongs_to :task, counter_cache: true, touch: true
	belongs_to :user
	scope :week_of, ->(date) {where(created_at: date.all_week) }
	scope :before, ->(date) {where('created_at <= ?',date.end_of_day)}
	default_scope { order(created_at: :asc) }

	# after_save :update_project_progress
	after_save :update_task_progress


	private
	# def update_project_progress
	# 	task.project.delay.update_progresses
	# end

	# Actualizamos el progreso de la tarea
	def update_task_progress
		task.progress = self.progress
		if resources
			task.resources = resources
		end
		task.save
	end
end
