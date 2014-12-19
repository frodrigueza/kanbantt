class ResourcesProgress < ActiveRecord::Base
	belongs_to :project

	scope :at, ->(date) {where(date: date) }
end
