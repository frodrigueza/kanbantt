class Comment < ActiveRecord::Base
	#Pertenece a una tarea
	belongs_to :task

	# pertenece a un usuario ya que no solo el dueño de la tarea puede dejar comentarios en esta, tambien el 
	# admin del proyecto y el super admin
	belongs_to :user

def wrap(s, width)
  s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1<br>").html_safe
end

	def method_name
		
	end
end
