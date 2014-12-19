# Servicio para exportar a xml
class Exporter

	def initialize(project)
		@project = project
		begin
			xml = File.open(@project.xml_file)
			p "Loading xml..."
			@hash = Hash.from_xml(xml)

			#Si el hash viene con las tasks en un arreglo llamado "Task" adentro de "Tasks", lo sacamos un nivel afuera
			# para que el arreglo quede en "Tasks"
			if @hash["Project"]["Tasks"]["Task"].count > 0
				hash = @hash
				hash["Project"]["Tasks"] = @hash["Project"]["Tasks"]["Task"]
				@hash = hash
			end
			p "Finished loading xml!"
		rescue
		end
	end

	def export
		hash = @hash["Project"]["Tasks"]
		# Se recorren las tareas
		(2..(hash.size-1)).each do |i|
			h = hash[i]
			# se actualiza el avance si existe la tarea
			if t = @project.tasks.find_by(mpp_uid:h["UID"].to_i)
				h["PercentComplete"] = t.progress.to_s
			end
		end
		@hash
	end

end