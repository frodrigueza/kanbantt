class Lock < ActiveRecord::Base
	belongs_to :locked, class_name: "Task"
	belongs_to :locker, class_name: "Task"
end
