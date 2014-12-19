module Api
  module V1

    class TasksController < ActionController::Base

      before_filter :restrict_access, only: [:index, :update]
      before_action :set_user, only: [:index, :update]
      #Con esto definimos como queremos entregar la respuesta.
      respond_to 'json'

############# Para mobile  #########

# Devuelve todas las tareas del proyecto que el usuario está solicitando

      def index
        respond_with Project.find(params[:project_id]).tasks
      end

      # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
      #-----------------------------UPDATE----------------------------------#
      #---------------------------------------------------------------------#
      #   Este método actualiza el porcentaje de avance de una tarea y,     #
      #   en caso de que se reporte un 100% de avance y el proyecto admite  #
      #   que se reporte en horas hombre, entonces se revisará el parámetro #
      #   man_hours para agregarlo a la tarea.                              #
      #   Requiere autorización del scope update. En caso de que haya       #
      #   vencido el token se devolverá uno nuevo                           #
      # --------------------------------------------------------------------#
      # ---------------------------PARAMS-----------------------------------#
      # => id: el id de la tarea que se va a actualizar                     #
      # => progress: el progreso de la tarea que se quiere reportar         #
      # => man_hours: horas hombre que se agregan a la task una vez         #
      #               terminada la tareas                                   #
      # ---------------------------RESPONSE---------------------------------#
      # status 200 si se creo el reporte y se actualizó la tareas           #
      # => task_id: id del task que se actualizo                            #
      # => progress: progreso de la tarea                                   #
      # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
      def update
        task = Task.find_by_id(params[:id])
        progress = params[:progress]
        if task
          #task.progress = progress #quitar si funciona solo con el report
          reporte = Report.new(task_id: task.id, progress: progress, user_id: @user.id)
          if progress.to_i == 100
            if Project.find_by_id(task.project_id).man_hours
              hh = params[:man_hours]
              task.man_hours = hh.to_i
            end
          end
          if task.save and reporte.save
            task.call_update
            render :json =>{task_id: task.id, progress: task.progress, status: 200}
          else
            render :json =>{false: 'la tarea no se pudo guardar', status: 304}
            head :no_content
          end
        else
          render :json =>{false: 'la tarea no existe', status: 304}
        end
      end
      ############# Termino mobile #######

      ############## Para web #######

      def show
        respond_with Task.find(params[:id])
      end

      def all
        @tasks = Project.find(params[:project_id]).tasks
        render :file => "api/v1/tasks/all.json.jbuilder",
               :content_type => 'application/json'
      end

      # Guarda los cambios de una tarea en gantt
      # Usa TaskFormatter para cambiar de los parámetros de task en Gantt
      # a los del modelo en Rails
      def update_gantt
        @task = Task.find(params[:id])
        formatted_params = TaskFormatter.new(params).from_gantt
        if @task.update(formatted_params)
          render nothing: true, status: :ok
        end
      end

      def create
        formatted_params = TaskFormatter.new(params).from_gantt
        @task = Task.new(formatted_params)
        if @task.save
          render nothing: true, status: :created
        end
      end

      def destroy
        @task = Task.find(params[:id])
        @task.destroy
        head :no_content
      end
      ############## Término web #########


      # Para restringir acceso el usuario debe entregar el token
      # Si este expiro, entonces será destruido
       private
       def restrict_access
        token=request.headers["Authorization"]
        set_api_key(token)
        if @ak
          unless @ak.valid_token
            @ak.destroy
          end
        end
        unless ApiKey.exists?(access_token: token)
          render nothing: 'HTTP_ACCESS_DENIED', status: '403'
        end
      end

      def set_user
        token = request.headers["Authorization"]
        set_api_key(token)
        @user = @ak.user if @ak
      end

      def set_api_key(token)
        @ak = ApiKey.find_by_access_token(token)
      end



    end

  end

end