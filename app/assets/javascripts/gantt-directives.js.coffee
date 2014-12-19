# Se define la directiva de Gantt para uso de dhtmlxGantt
angular.module('Gantt.gantt-directives', [])
  .directive "dhxGantt", ["Api",'$location',  (Api, $location) ->
    restrict: "A"
    scope: false
    transclude: true
    template: "<div ng-transclude></div>"
    link: ($scope, $element, $attrs, $controller) ->
      $.blockUI()
      #watch data collection, reload on changes
      $scope.$watch $attrs.data, ((collection) ->
        if collection
          gantt.clearAll()
          gantt.parse collection, "json"
      ), true
      gantt.config.fit_tasks = true;
      gantt.config.columns = [
        {
          name: "text"
          label: "Nombre de tarea"
          tree: true
          width: "*"
        }

        #{
        #  name: "start_date"
        #  label: "Fecha de inicio"
        #  align: "center"
        #}
        {
          name: "task_duration"
          label: "Duración"
          align: "center"
        }
        {
          name: "progress"
          label: "Avance"
          align: "center"
          template: (obj) ->
            Math.round(obj.progress*100) + " %"
        }
        #{
        #  name: "add"
        #  label: ""
        #}
      ]
      gantt.addMarker
        start_date: new Date() #a Date object that sets the marker's date
        css: "today" #a CSS class applied to the marker
        text: "Hoy" #the marker title
        title: (new Date()).toString() #the marker's tooltip

      gantt.config.show_task_cells = false
      gantt.static_background = true;
      gantt.config.work_time = true;
      gantt.config.correct_work_time = true;
      gantt.config.drag_links = false;
      #init gantt
      gantt.init $element[0]
      
      # guarda tareas nuevas en db a través de un post a la api
      gantt.attachEvent "onBeforeTaskAdd", (id, new_item) ->
        Api.Task.save({project_id: $scope.projectId}, new_item)

      # actualiza tareas en db a través de un put a la api
      gantt.attachEvent "onAfterTaskUpdate", (id, item) ->
        Api.Task.update({project_id: $scope.projectId, task_id:item.id}, item)

      # borra tareas en db a través de un delete a la api
      gantt.attachEvent "onBeforeTaskDelete", (id,item) ->
        Api.Task.delete({project_id: $scope.projectId, task_id:item.id}, item)
        $scope.tasks.data.pop()
      
      gantt.attachEvent "onGanttRender", (id, e) ->
        if($('.gantt_row').size() > 0)
          $.unblockUI()


     
      gantt.attachEvent "onTaskDblClick", (id, e) ->
        #bloquear lightbox que viene en la libreria por default
      gantt.templates.tooltip_text = (start, end, task) ->
        "<b>Tarea:</b> " + task.text + "<br/><b>Encargado:</b> " + (task.users || "") + "<br/><b>Avance:</b> " + Math.round(task.progress*100) + " %" 

      gantt.templates.task_text = (start, end, task) ->
        task.text

      # Botón que activa o desactiva ruta crítica
      # enabled = alert
      # $scope.toggleCriticalPath = ->
      #   enabled = !enabled
      #   gantt.config.highlight_critical_path = enabled
      #   gantt.render()


      $scope.toggleScale = ->
        if gantt.config.scale_unit == "day"
          gantt.config.scale_unit = "month"
          gantt.config.drag_progress = false;
          gantt.templates.task_text = (start, end, task) ->
            ""
          gantt.config.date_scale = "%F %Y"
          $('#month').toggleClass( "active")
          $('#day').toggleClass( "active")
          $.each gantt.getChildren(0), (key, value) ->
            gantt.close value
          gantt.render()
        else

          gantt.config.scale_unit = "day"
          gantt.templates.task_text = (start, end, task) ->
            task.text
          gantt.config.date_scale = "%d %M"
          $('#day').toggleClass( "active")
          $('#month').toggleClass( "active")
          $.each gantt.getChildren(0), (key, value) ->
            gantt.open value
          gantt.render()

  ]

  .directive "dhxGanttProjects", ["Api",'$location',  (Api, $location) ->
    restrict: "A"
    scope: false
    transclude: true
    template: "<div ng-transclude></div>"
    link: ($scope, $element, $attrs, $controller) ->
      $.blockUI()
      #watch data collection, reload on changes
      $scope.$watch $attrs.data, ((collection) ->
        if collection
          gantt.clearAll()
          gantt.parse collection, "json"
      ), true
      gantt.config.fit_tasks = true;
      gantt.config.autofit = true;
      gantt.config.columns = [
        {
          name: "text"
          label: "Nombre"
          tree: true
          width: "*"
        }
        {
          name: "progress"
          label: "Avance"
          align: "center"
          template: (obj) ->
            Math.round(obj.progress*100) + " %"
        }
      ]
      gantt.addMarker
        start_date: new Date() #a Date object that sets the marker's date
        css: "today" #a CSS class applied to the marker
        text: "Hoy" #the marker title
        
     # $scope.tasks.first.type =  gantt.config.types.project
      gantt.config.initial_scroll = false
      gantt.config.show_task_cells = false
      gantt.static_background = true
      gantt.config.scale_unit = "month"
      gantt.config.drag_progress = false
      gantt.config.drag_move = false
      gantt.config.show_links = false
      gantt.config.drag_resize = false
      gantt.config.date_scale = "%M %Y"
      #init gantt
      gantt.init $element[0]

      
     
      gantt.attachEvent "onGanttRender", (id, e) ->
        if($('.gantt_row').size() > 0)
          gantt.showDate(new Date())
          $.unblockUI()
     
      gantt.attachEvent "onTaskDblClick", (id, e) ->
        #bloquear lightbox que viene en la libreria por default

      gantt.attachEvent "onGanttReady", (id,e) ->
        

      gantt.templates.tooltip_text = (start, end, task) ->
        "<b>Proyecto:</b> " + task.text + "<br/><b>Avance:</b> " + Math.round(task.progress*100) + " %" 

      gantt.templates.task_text = (start, end, task) ->
        task.text

     
          

  ]