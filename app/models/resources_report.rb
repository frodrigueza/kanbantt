class ResourcesReport < ActiveRecord::Base

	belongs_to :task
	belongs_to :user
	scope :week_of, ->(date) {where(created_at: date.all_week) }
	scope :before, ->(date) {where('created_at <= ?',date.end_of_day)}
	default_scope { order(created_at: :asc) }

	after_save :update_project_progress


	private
	def update_project_progress
		task.project.update_progresses
	end

end
