# Archivo principal de gráficos
# Para manejo de turbolinks se define funcion start
# start carga el js si se encuentra el elemento #chart
start = ->
  angular.bootstrap document.getElementById('indicators'), ["Chart"] if $("#indicators")[0]
  $("#chart").css('visibility','hidden')
  # Cambia color del indicador, según diferencia positiva (adelantado) o negativa (atrasado)
  setDifferenceColor()
  #  Trigger un resize falso para que el highchart escondido actualice su tamaño.
  $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
  	$(window).resize()

$(document).on "ready page:load", start

# Se crea el módulo Chart con sus dependencias
angular.module('Chart', ['highcharts-ng', 'ngResource', 'Chart.chart-factories', 'Chart.chart-controllers'])

setDifferenceColor = ->
 $('.middle-indicator').each (index, element) =>
  if $(element).data('difference-positive')
  	$(element).addClass('positive')
  else
  	$(element).addClass('negative')