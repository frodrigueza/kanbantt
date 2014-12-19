
$(function(){
	// Metodo que crea la funcion selectedModifier y suscribe el select a esta
	var filter = function(){

		// Metodo que oculta o muestra segun el filtro seleccionado
		var selectedModifier = function(){

			// rango de tiempo 
			var daysRange;
			// almacenamos el valor seleccionado
			var date_select = $('#date_select_filter').val();
			var status_select = $('#status_select_filter').val();

			// segun el valor seleccionado en el select definimos el rango de tiempo a filtrar
			switch(date_select)
			{
				case 'Hoy':
					daysRange = 1;
					break;
				case 'Una semana':
					daysRange = 7;
					break;
				case '15 días':
					daysRange = 15;
					break;
				case '1 mes':
					daysRange = 30;
					break;
				case 'Todos':
					daysRange = Number.POSITIVE_INFINITY;
					break;
			}

			// para cada item dentro del kanban 
			$('.kanban_item').each(function(index, value){
				// obtenemos las fechas de inicio y termino almacenadas en el html
				var start_date = Date.parse($(this).data('startdate'));
				var end_date = Date.parse($(this).data('enddate'));
				var today = $.now();
				// creamos una variable auxiliar que represente un día (multiplicación)
				var oneDay = 24*60*60*1000;
				// alamcenamos el numero de días entre el termino de la tarea hasta hoy
				var diffDaysEnd = Math.round((end_date - today)/(oneDay));
				if (diffDaysEnd < 0) 
				{
					diffDaysEnd = Number.POSITIVE_INFINITY;
				}
				// alamcenamos el numero de días entre el inicio de la tarea hasta hoy
				var diffDaysStart = Math.round((start_date - today)/(oneDay));
				if (diffDaysStart < 0) 
				{
					diffDaysStart = Number.POSITIVE_INFINITY;
				}

				var status = $(this).data('status');
				// console.log(status);


				var show = false;
				switch(status_select)
				{
					case 'Atrasadas':
						// al seleccionar las atrasadas, no se filtran por periodo de inicio ni termino, sino que se muestran todas
						$('#date_select_filter_td').hide();

						if (status == 'delayed') 
						{
							show = true;
						}
						else
						{
							show = false;
						}

						break;

					case 'Todos':
						$('#date_select_filter_td').show();
						if(diffDaysStart > daysRange && diffDaysEnd > daysRange)
						{
							show = false;
						}
						else
						{
							show = true
						}

						break;	
					case 'Comienzan en':
						$('#date_select_filter_td').show();
						// si entra al rango se muestra, sino se oculta
						if(diffDaysStart > daysRange)
						{
							show = false;
						}
						else
						{
							show = true
						}
						break;
					case 'Terminan en':
						$('#date_select_filter_td').show();
						// si entra al rango se muestra, sino se oculta
						if(diffDaysEnd > daysRange)
						{
							show = false;
						}
						else
						{
							show = true
						}
						break;
				}

				// ahora mosramos si la variable show quedo en true (agregando la clase hidden_by_date que tiene display:none;)
				switch (show){
					case true:
						$(this).removeClass('hidden_by_date');
						break;
					case false:
						$(this).addClass('hidden_by_date');
						break;
				}


			});

			//actualizamos los contadores
			updateCounters();
		}


		// Suscribimos select de fecha a change() para que cada vez que se cambia el select de fecha
		$('#date_select_filter').change(selectedModifier);
		$('#status_select_filter').change(selectedModifier);


		//por defecto que se muestre las actividades de esta semana (es el primero de las opciones y el metodo toma la opcion seleccionada)
		selectedModifier();
	};

	// metodo que actualiza el contador de las columnas

	$(document).ready(filter);
	$(document).on('page:load', filter);
});

// dejamos esta funcion fuera del scope para poder llamarla desde otros archivos. (kanban.js)
var updateCounters = function(){
	$('#inactive_counter').html("(" + $('#inactive_kanban_column').find('.kanban_item').filter(":visible").size() + ")");
	$('#in_progress_counter').html("(" + $('#in_progress_kanban_column').find('.kanban_item').filter(":visible").size() + ")");
	$('#done_counter').html("(" + $('#done_kanban_column').find('.kanban_item').filter(":visible").size() + ")");
}
