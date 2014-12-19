class TaskPosition < ActiveRecord::Base
	# belongs_to :columns
	# belongs_to :task, foreign_key: 'task_id'
	# belongs_to :project, foreign_key: 'project_id'
	# validates :task_id, uniqueness: true

	# def from_user?(user)
	#     task.user == user
 #  	end

 #  	# Este método se encarga de actualizar el progreso de una tarea si es que es movida a la columna
 #  	# finalizada y su reporte es menor a 100%
 #  	def report_progress(user)
 #  		if task.reports.last
	#   		if column_id == 3 and task.reports.last.progress.to_i != 100
	#         	report_completed(user)
	#         end
	#     else
	#     	if column_id == 3
	#     		report_completed(user)
	#     	end
	#     end
 #    end

 #    #Reportar avance completo
 #    def report_completed(user)
 #  		r = Report.new(task_id: task.id, progress: 100, user_id: user.id)
	#     r.save
 #    end
    
 #    def set_position(column, pos, user)
 #    	self.column_id = column
 #    	self.position = pos
 #    	self.save
 #        report_progress(user)
 #    end
end
