# Se define Factory de Progress para agregar avances al Grafico
angular.module('Chart.chart-factories', [])
	.factory "Api", [ "$resource", ($resource) ->
  return (
    EstimatedDaysProgress: $resource("/api/progress/estimated_in_days_by_week", {project_id: "@project_id" })
    RealDaysProgress: $resource("/api/progress/real_in_days_by_week", {project_id: "@project_id" })
    EstimatedResourcesProgress: $resource("/api/progress/estimated_in_resources_by_week", {project_id: "@project_id" })
    RealResourcesProgress: $resource("/api/progress/real_in_resources_by_week", {project_id: "@project_id" })	
    PerformanceEstimated: $resource("/api/progress/performance_estimated_by_week", {project_id: "@project_id" })
    PerformanceReal: $resource("/api/progress/performance_real_by_week", {project_id: "@project_id" })



  	# EstimatedTaskResourcesProgress: $resource("/api/progress/estimated_task_in_resources",{project_id: "@project_id", task_id: "@task_id"})
  	# EstimatedTaskDaysProgress: $resource("/api/progress/estimated_task_in_days",{project_id: "@project_id", task_id: "@task_id"})
  	# RealTaskResourcesProgress: $resource("/api/progress/real_task_in_resources",{project_id: "@project_id", task_id: "@task_id"})
  	# RealDaysProgress: $resource("/api/progress/real_task_in_days",{project_id: "@project_id", task_id: "@task_id"})

  	)
]
