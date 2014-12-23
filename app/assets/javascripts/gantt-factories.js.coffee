# Se definen Factories de Project, Lock y Task para agregarlos a la Gantt
angular.module('Gantt.gantt-factories', [])
	.factory "Api", [ "$resource", ($resource) ->
  return (
  	Project: $resource("/api/projects/all")
  	TaskAll: $resource("/api/projects/:project_id/tasks/all", {project_id: "@project_id", id: '@id'})
  	Task: $resource("/api/projects/:project_id/tasks/:task_id/update_gantt", {project_id: "@project_id", task_id: '@task_id'}, {update: {method: "PUT"}})
  	)
]