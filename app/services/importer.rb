# Servicio para importar de xml
class Importer

	# def initialize(path, upload_path)
	# 	@upload_path = upload_path
	# 	xml = File.open(path)
	# 	p "Loading xml..."
	# 	@hash = Hash.from_xml(xml)
	# 	p "Finished loading xml!"
	# end

	def initialize(file_upload)

		# El path donde se va a guardar el archivo
		Dir.mkdir 'public/uploads' unless File.directory?('public/uploads')
		upload_path = Rails.root.join('public', 'uploads', file_upload.original_filename)

		# Si ya existe un archivo con el mismo nombre se crea con un número (i)
		if File.exist? upload_path.to_s
			i=1
			path = upload_path.to_s.insert(-4, "(#{i.to_s})")
			while File.exist? path do
				i = i+1
			end
			name = file_upload.original_filename.insert(-5, "(#{i.to_s})")
			upload_path = Rails.root.join('public', 'uploads', name)
		end

		# Se crea el archivo en el path
		File.open(upload_path, 'wb') do |file|
			file.write(file_upload.read)
		end

		@upload_path = upload_path.to_s
		xml = File.open(file_upload.path())
		p "Loading xml..."
		@hash = Hash.from_xml(xml)
		p "Finished loading xml!"
	end

	def import(project)
		hours_per_day = @hash["Project"]["MinutesPerDay"].to_i/60
		hash = @hash["Project"]["Tasks"]["Task"]
		Task.transaction do
			# Primero se crea el proyecto
			project.name = hash[1]["Name"]
			project.expected_start_date = hash[1]["Start"].to_date
			project.expected_end_date = hash[1]["Finish"].to_date
			project.xml_file = @upload_path
			project.sneaky_save

			#Asignamos el proyecto
			out_line = 1
			last = nil

			# Se recorren las tareas
			# out_line_level = 1 es el proyecto
			(2..(hash.size-1)).each do |i|
				h = hash[i]
				# saco duración en horas de atributo Duration del xml
				# Formato: PThorasHminutosMsegundosS
				duration = h["Duration"].match('PT(.*?)H')[1].to_i / hours_per_day
				cost = h["Cost"].to_f > 0 ? h["Cost"].to_f : 0
				t = Task.new(name:h["Name"], expected_start_date:(h["Start"]).to_date, expected_end_date:(h["Finish"]).to_date, project_id:project.id, resources_cost:cost, mpp_uid:h["UID"].to_i)
				t.sneaky_save

				# Si es de ultimo nivel se agrega al kanban
				if(h["Type"].to_i == 0)
					# si tiene avance y es de ultimo nivel se reporta
					if(h["PercentComplete"].to_i> 0)
						r = Report.new(task_id:t.id, progress: h["PercentComplete"].to_i, created_at:Time.now)
						r.sneaky_save
					end
				end
				
				# si es primer hijo
				if out_line == 1 #last == nil
					project.children << t
				# si es un hijo de la anterior
				elsif h["OutlineLevel"].to_i > out_line
					last.children << t
				# si es un hermana de la anterior
				elsif h["OutlineLevel"].to_i == out_line
					last.parent ? last.parent.children << t  : project.children << t
				# si es tia de la anterior
				else
					ascendence = out_line - h["OutlineLevel"].to_i
					node = last.parent
					if h["OutlineLevel"].to_i == 2
						project.children << t
					else 
						ascendence.times do
							node = node.parent 
						end
						node.children << t
					end
				end
				out_line = h["OutlineLevel"].to_i
				last = t
			end
			#calcula progresos
			# p.calculate_progresses
			return project
		end
	end
end