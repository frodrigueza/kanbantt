#Se define el controlador GanttCrtl que obtiene todos los proyectos
angular.module('Gantt.gantt-controllers', [])
  # Este controlador se usaria para el ruteo
  # .controller "AppCtrl", ["$scope", "$location", ($scope, $location) ->
  #   url = $location.absUrl().split('/')
  #   $scope.projectId = url[4]
  # ]
  .controller "GanttCtrl", [ "$scope", "Api", '$location', ($scope, Api, $location) ->
    url = $location.absUrl().split('/')
    $scope.projectId = url[4]
    $scope.projects = false
    $scope.tasks = links: [], data: Api.TaskAll.query({project_id: $scope.projectId})
  ]
  .controller "ProjectsCtrl", [ "$scope", "Api", '$location', ($scope, Api, $location) ->
    $scope.projects = true
    $scope.tasks = 
      links: [], 
      data: Api.Project.query()
  ]