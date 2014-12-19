class KanbanBoardController < ApplicationController

  # Este método es para el kanban de un proyecto, filtra automáticamente
  # por usuario que hace el request y por el proyecto en que me encuentro
  # @return 
  #  - @columns: Todas las columnas
  #  - @taskPositions: Arreglo con las tarjetas del kanban correspondientes
  #  - @project: Proyecto  en caso de que sea la vista de uno solo
  def index
    if @project
      @inactive_tasks = @project.kanban_inactive_tasks
      @in_progress_tasks = @project.kanban_in_progress_tasks
      @done_tasks = @project.kanban_done_tasks
    else
      @inactive_tasks = current_user.kanban_inactive_tasks
      @in_progress_tasks = current_user.kanban_in_progress_tasks
      @done_tasks = current_user.kanban_done_tasks
    end
  end

  def update_item_partial
    @task = Task.find(params[:task_id])

    respond_to do |format|
      format.js
    end
  end


  # Filtramos las tareas que le pertenecen al usuario
  # @return: un arreglo con las tareas que corresponden a ese usuario
  def from_user(user)
    user_tasks = Array.new
    if @taskPositions
      @taskPositions.each { |tp|
        if tp.from_user?(user)
          user_tasks << tp
        end
      }
    end
    user_tasks
  end


  # Este método es el que se encarga de actualizar las posiciones de los objetos
  # cuando es  llamado vía ajax desde el application.js, además si una tarea fue movida a la tercera columna
  # se actualiza el porcentaje de avaance a 100%
  # @input
  # params["orden"] es de la siguiente forma "id=1|sort=5&sort=9..." donde el id es el id de la columna
  # y los numeros de sort son los id de los tasks
  # def update
  #   primera_division = params["orden"].split('|')
  #   id_col = primera_division[0].split('=')[1].to_i
  #   segunda_division = primera_division[1].split('&')

  #   #Para cada elemento seteamos la posición en que se encuentra dentro de la lista
  #   position = 1
  #   segunda_division.each { |e|
  #     if e.split('=')[1]
  #       task_id = (e.split('=')[1]).to_i
  #       tp = TaskPosition.find_by(task_id: task_id)
  #       tp.set_position(id_col, position, current_user)
  #       position = position + 1
  #     end
  #   }
  # end

end
