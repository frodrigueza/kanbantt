#Se definen controladores para los gráficos
angular.module('Chart.chart-controllers', [])
 .controller "ResourcesChartCtrl", ["$scope", "Api", '$location', ($scope, Api, $location) ->
    Highcharts.setOptions lang:
      loading: "Cargando..."
      months: [
        "Enero"
        "Febrero"
        "Marzo"
        "Abril"
        "Mayo"
        "Junio"
        "Julio"
        "Agosto"
        "Septiembre"
        "Octubre"
        "Noviembre"
        "Diciembre"
      ]
      shortMonths: [
        "Ene"
        "Feb"
        "Mar"
        "Abr"
        "May"
        "Jun"
        "Jul"
        "Ago"
        "Sep"
        "Oct"
        "Nov"
        "Dic"
      ]
      weekdays: [
        "Domingo"
        "Lunes"
        "Martes"
        "Miercoles"
        "Jueves"
        "Viernes"
        "Sábado"
      ]
      shortMonths: [
        "Ene"
        "Feb"
        "Mar"
        "Abr"
        "May"
        "Jun"
        "Jul"
        "Ago"
        "Sep"
        "Oct"
        "Nov"
        "Dic"
      ]
      exportButtonTitle: "Exportar"
      printButtonTitle: "Importar"
      rangeSelectorFrom: "De"
      rangeSelectorTo: "A"
      rangeSelectorZoom: "Periodo"
      resetZoom: "Resetear zoom"
      downloadPNG: "Descargar gráfica PNG"
      downloadJPEG: "Descargar gráfica JPEG"
      downloadPDF: "Descargar gráfica PDF"
      downloadSVG: "Descargar gráfica SVG"
      printChart: "Imprimir Gráfica"
      thousandsSep: ","
      decimalPoint: "."


    url = $location.absUrl().split('/')
    $scope.projectId = url[4]

    $scope.estimated_pairs = Api.EstimatedResourcesProgress.get({project_id: $scope.projectId})
      .$promise.then (data) ->
        $scope.estimated_pairs = data
        angular.forEach $scope.estimated_pairs.data, (data) ->
          data[0] = Date.parse(data[0])

        $scope.real_pairs = Api.RealResourcesProgress.get({project_id: $scope.projectId})
          .$promise.then (data) ->
            $scope.real_pairs = data
            $("#chart").css('visibility','visible')
            angular.forEach $scope.real_pairs.data, (data) ->
              data[0] = Date.parse(data[0])

            # Como js toma la zona horaria, le ajustamos el día actual para que salga a la misma hora que los datos obtenidos
            $scope.today = new Date()
            $scope.today.setDate($scope.today.getDate()-1)
            $scope.today.setHours(21)
            $scope.today.setMinutes(0)
            $scope.today.setSeconds(0)

            $scope.highchartsNG =
              options:
                chart:
                  type: "line"
                  zoomType: "x"

              credits: 
                  enabled: false
              
              dateTimeLabelFormats: {
                    week: '%A, %b %e'
                    month: '%e. %b',
                    year: '%b'
              }
              xAxis: {
                type: 'datetime',
                plotLines: [
                  color: 'gray'
                  dashStyle: 'shortdash'
                  value: $scope.today
                  width: '1'
                  label:
                    text: "Hoy"
                ]

              },
              yAxis: {
                  min: 0,
                  max: 100,
                  title: 
                    enabled: false
              },
              series: [
                  {
                    data: $scope.estimated_pairs.data,
                    tooltip: 
                      valueSuffix: '%'
                      dateTimeLabelFormats: 
                        week: '%A %e %b, %Y'
                    name: 'Avance Esperado'
                  },
                  {
                    data: $scope.real_pairs.data,
                    tooltip: 
                      valueSuffix: '%'
                      dateTimeLabelFormats: 
                        week: '%A %e %b, %Y'
                      
                    name: 'Avance Real'
                  }
              ],
              title:
                text: "Avance"
                align: 'left'
              subtitle:
                text: "en base a recursos"
                align: 'left'

              
              loading: false
          
  ]
  .controller "DaysChartCtrl", ["$scope", "Api", '$location', ($scope, Api, $location) ->
    url = $location.absUrl().split('/')
    $scope.projectId = url[4]
    $scope.estimated_pairs = Api.EstimatedDaysProgress.get({project_id: $scope.projectId})
      .$promise.then (data) ->
        $scope.estimated_pairs = data
        angular.forEach $scope.estimated_pairs.data, (data) ->
          data[0] = Date.parse(data[0])

        $scope.real_pairs = Api.RealDaysProgress.get({project_id: $scope.projectId})
          .$promise.then (data) ->
            $scope.real_pairs = data
            $("#chart").css('visibility','visible')
            angular.forEach $scope.real_pairs.data, (data) ->
              data[0] = Date.parse(data[0])

            # Como js toma la zona horaria, le ajustamos el día actual para que salga a la misma hora que los datos obtenidos
            $scope.today = new Date()
            $scope.today.setDate($scope.today.getDate()-1)
            $scope.today.setHours(21)
            $scope.today.setMinutes(0)
            $scope.today.setSeconds(0)

            $scope.highchartsNG =
              options:
                chart:
                  type: "line"
                  zoomType: "x"

              credits: 
                  enabled: false
              
              dateTimeLabelFormats: {
                    week: '%A, %b %e'
                    month: '%e. %b',
                    year: '%b'
              }
              xAxis: {
                type: 'datetime',
                plotLines: [
                  color: 'gray'
                  dashStyle: 'shortdash'
                  value: $scope.today
                  width: '1'
                  label:
                    text: "Hoy"
                ]

              },
              yAxis: {
                  min: 0,
                  max: 100,
                  title: 
                    enabled: false
              },
              series: [
                  {
                    data: $scope.estimated_pairs.data,
                    tooltip: 
                      valueSuffix: '%'
                      dateTimeLabelFormats: 
                        week: '%A %e %b, %Y'
                    name: 'Avance Esperado'
                  },
                  {
                    data: $scope.real_pairs.data,
                    tooltip: 
                      valueSuffix: '%'
                      dateTimeLabelFormats: 
                        week: '%A %e %b, %Y'
                      
                    name: 'Avance Real'
                  }
              ],
              title:
                text: "Avance"
                align: 'left'
              subtitle:
                text: "en base a tiempo"
                align: 'left'

              
              loading: false
          
  ]
  .controller "DesempenoChartCtrl", ["$scope", "Api", '$location', ($scope, Api, $location) ->
    url = $location.absUrl().split('/')
    $scope.projectId = url[4]
    $scope.estimated_pares = Api.PerformanceEstimated.get({project_id: $scope.projectId})
      .$promise.then (data) ->
        $scope.estimated_pares = data
        angular.forEach $scope.estimated_pares.data, (data) ->
          data[0] = Date.parse(data[0])

        $scope.real_pares = Api.PerformanceReal.get({project_id: $scope.projectId})
          .$promise.then (data) ->
            $scope.real_pares = data
            $("#chart").css('visibility','visible')
            angular.forEach $scope.real_pares.data, (data) ->
              data[0] = Date.parse(data[0])

            # Como js toma la zona horaria, le ajustamos el día actual para que salga a la misma hora que los datos obtenidos
            $scope.today = new Date()
            $scope.today.setDate($scope.today.getDate()-1)
            $scope.today.setHours(21)
            $scope.today.setMinutes(0)
            $scope.today.setSeconds(0)

            $scope.highchartsNG =
              options:
                chart:
                  type: "line"
                  zoomType: "x"

              credits: 
                  enabled: false
              
              dateTimeLabelFormats: {
                    week: '%A, %b %e'
                    month: '%e. %b',
                    year: '%b'
              }
              xAxis: {
                type: 'datetime',
                plotLines: [
                  color: 'gray'
                  dashStyle: 'shortdash'
                  value: $scope.today
                  width: '1'
                  label:
                    text: "Hoy"
                ]

              },
              yAxis: {
                  min: 0,
                  title: 
                    enabled: false
              },
              series: [
                  {
                    data: $scope.estimated_pares.data,
                    tooltip: 
                      valueSuffix: ''
                      dateTimeLabelFormats: 
                        week: '%A %e %b, %Y'
                    name: 'Cantidad de recursos esperada'
                  },
                  {
                    data: $scope.real_pares.data,
                    tooltip: 
                      valueSuffix: ''
                      dateTimeLabelFormats: 
                        week: '%A %e %b, %Y'
                      
                    name: 'Cantidad de recursos real'
                  }
              ],
              title:
                text: "Desempeño"
                align: 'left'
              subtitle:
                text: "en base a cantidad de recursos"
                align: 'left'

              
              loading: false
          
  ]


  # .controller "ResourcesTaskChartCtrl", ["$scope", "Api", '$location', ($scope, Api, $location) ->
  #   console.log url = $location.absUrl().split('/')
  #   $scope.taskId = url[4]
  #   #$scope.taskId = 
  #   $scope.estimated_pairs = Api.EstimatedTaskResourcesProgress.get({task_id: $scope.taskId})
  #     .$promise.then (data) ->
  #       $scope.estimated_pairs = data
  #       angular.forEach $scope.estimated_pairs.data, (data) ->
  #         data[0] = Date.parse(data[0])

  #       $scope.real_pairs = Api.RealTaskResourcesProgress.get({task_id: $scope.taskId})
  #         .$promise.then (data) ->
  #           $scope.real_pairs = data
  #           $("#chart").css('visibility','visible')
  #           angular.forEach $scope.real_pairs.data, (data) ->
  #             data[0] = Date.parse(data[0])

  #           # Como js toma la zona horaria, le ajustamos el día actual para que salga a la misma hora que los datos obtenidos
  #           $scope.today = new Date()
  #           $scope.today.setDate($scope.today.getDate()-1)
  #           $scope.today.setHours(21)
  #           $scope.today.setMinutes(0)
  #           $scope.today.setSeconds(0)

  #           $scope.highchartsNG =
  #             options:
  #               chart:
  #                 type: "line"
  #                 zoomType: "x"

  #             credits: 
  #                 enabled: false
              
  #             dateTimeLabelFormats: {
  #                   week: '%A, %b %e'
  #                   month: '%e. %b',
  #                   year: '%b'
  #             }
  #             xAxis: {
  #               type: 'datetime',
  #               plotLines: [
  #                 color: 'gray'
  #                 dashStyle: 'shortdash'
  #                 value: $scope.today
  #                 width: '1'
  #                 label:
  #                   text: "Hoy"
  #               ]

  #             },
  #             yAxis: {
  #                 min: 0,
  #                 max: 100,
  #                 title: 
  #                   enabled: false
  #             },
  #             series: [
  #                 {
  #                   data: $scope.estimated_pairs.data,
  #                   tooltip: 
  #                     valueSuffix: '%'
  #                     dateTimeLabelFormats: 
  #                       week: '%A %e %b, %Y'
  #                   name: 'Avance Estimado'
  #                 },
  #                 {
  #                   data: $scope.real_pairs.data,
  #                   tooltip: 
  #                     valueSuffix: '%'
  #                     dateTimeLabelFormats: 
  #                       week: '%A %e %b, %Y'
                      
  #                   name: 'Avance Real'
  #                 }
  #             ],
  #             title:
  #               text: "Avance"
  #               align: 'left'
  #             subtitle:
  #               text: "en base a recursos"
  #               align: 'left'

              
  #             loading: false
          
  # ]

  # .controller "DaysTaskChartCtrl", ["$scope", "Api", '$location', ($scope, Api, $location) ->
  #   url = $location.absUrl().split('/')
  #   $scope.projectId = url[4]
  #   console.log $('.grafresumen')
  #   $scope.estimated_pairs = Api.EstimatedDaysProgress.get({project_id: $scope.projectId})
  #     .$promise.then (data) ->
  #       $scope.estimated_pairs = data
  #       angular.forEach $scope.estimated_pairs.data, (data) ->
  #         data[0] = Date.parse(data[0])

  #       $scope.real_pairs = Api.RealDaysProgress.get({project_id: $scope.projectId})
  #         .$promise.then (data) ->
  #           $scope.real_pairs = data
  #           $("#chart").css('visibility','visible')
  #           angular.forEach $scope.real_pairs.data, (data) ->
  #             data[0] = Date.parse(data[0])

  #           # Como js toma la zona horaria, le ajustamos el día actual para que salga a la misma hora que los datos obtenidos
  #           $scope.today = new Date()
  #           $scope.today.setDate($scope.today.getDate()-1)
  #           $scope.today.setHours(21)
  #           $scope.today.setMinutes(0)
  #           $scope.today.setSeconds(0)

  #           $scope.highchartsNG =
  #             options:
  #               chart:
  #                 type: "line"
  #                 zoomType: "x"

  #             credits: 
  #                 enabled: false
              
  #             dateTimeLabelFormats: {
  #                   week: '%A, %b %e'
  #                   month: '%e. %b',
  #                   year: '%b'
  #             }
  #             xAxis: {
  #               type: 'datetime',
  #               plotLines: [
  #                 color: 'gray'
  #                 dashStyle: 'shortdash'
  #                 value: $scope.today
  #                 width: '1'
  #                 label:
  #                   text: "Hoy"
  #               ]

  #             },
  #             yAxis: {
  #                 min: 0,
  #                 max: 100,
  #                 title: 
  #                   enabled: false
  #             },
  #             series: [
  #                 {
  #                   data: $scope.estimated_pairs.data,
  #                   tooltip: 
  #                     valueSuffix: '%'
  #                     dateTimeLabelFormats: 
  #                       week: '%A %e %b, %Y'
  #                   name: 'Avance Estimado'
  #                 },
  #                 {
  #                   data: $scope.real_pairs.data,
  #                   tooltip: 
  #                     valueSuffix: '%'
  #                     dateTimeLabelFormats: 
  #                       week: '%A %e %b, %Y'
                      
  #                   name: 'Avance Real'
  #                 }
  #             ],
  #             title:
  #               text: "Avance"
  #               align: 'left'
  #             subtitle:
  #               text: "en base a tiempo"
  #               align: 'left'

              
  #             loading: false
          
  # ]
