class TaskFormatter
	
	# Este servicio formatea los parámetros que posee el modelo para pasarlos a la 
	# Api de la Carta Gantt

	def initialize(params)
		@params = params
	end

	def from_gantt
		new_params = {
			id: @params[:id],
			progress: @params[:progress].to_f*100,
			name: @params[:text],
			expected_start_date: @params[:start_date],
			expected_end_date: @params[:end_date],
			parent_id: @params[:parent],
			project_id: @params[:project_id]
		}
	end
end