# Archivo principal de la gantt
# Para manejo de turbolinks se define funcion start
# start carga el js si se encuentra el elemento #gantt 
start = ->
  angular.bootstrap "body", ["Gantt"]  if $("#gantt")[0]
 #  $('.horizontal_sub_menu').hide() unless $('#pl4').hasClass('activo')
 #  $('.gantt-menu').hover (->
  #   $('.horizontal_sub_menu').show()
  # ), ->
  #   $('.horizontal_sub_menu').hide() unless $('#pl4').hasClass('activo')

# La funcion start se gatilla tanto al cargar inicialmente
# como al hacer un load con turbolinks
$(document).on('ready page:load', start)

# Se crea el modulo Gantt 
# Las dependencias son ngResource, ngRoute y modulos de controllers, factories y directives.
angular.module('Gantt', ['ngResource', 'ngRoute', 'Gantt.gantt-controllers', 'Gantt.gantt-factories', 'Gantt.gantt-directives'])


#Pueden servir para arreglar el ruteo
# app.config(['$routeProvider', '$locationProvider',  ($routeProvider, $locationProvider) ->
#   $routeProvider.when "/projects/:projectId/gantt/",
#     event: "gantt.show"
# ])

# app.controller "AppCtrl", ["$scope", "$location","$routeParams", "$route", ($scope, $location, $routeParams, $route) ->
#   console.log $routeParams
#   $route.reload()
#   #console.log $route[0].routes
#   #console.log $scope.projectId = $route.routes['/projects/:projectId/gantt/'].keys[0].name
#   console.log $route
#   $scope.projectId = $routeParams.projectId
# ]

# Métodos para crear un console.last() en consola que entregue el útimo log como objeto
_log = console.log
console.log = ->
  
  # turn arguments into an array and store it
  @_last = [].slice.call(arguments)
  
  # call the original function
  _log.apply console, arguments
  return

console.last = ->
  @_last