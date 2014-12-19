class Column < ActiveRecord::Base
	has_many :task_positions
	has_many :tasks, through: :task_positions

	def quantity(colid, proid)
		if(proid == 0)
			return task_positions.count
		else
			return task_positions.where(project_id: proid).count
		end
		
	end

end
