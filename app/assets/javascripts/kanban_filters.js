var filter = function(search_field_id){

	$.each($('.sortable_kanban_item'), function(index, value){
		var id = value.id;
		var task_name = $('#' + id).find(".task_name").text();
		var text = $('#' + search_field_id).val();

		if (task_name.toLowerCase().indexOf(text) >= 0)
		{
			$('#' + id).removeClass('hidden_by_name');
		}
		else
		{
			$('#' + id).addClass('hidden_by_name');
		}

	});

	
};

var suscribe_search_filter = function(){
	$('.search_field').keyup(function(){
		filter(this.id);
	});
};

$(function(){
	suscribe_search_filter;
});


// Suscripciones luego de llegar por un turbolink
$(document).ready(suscribe_search_filter);
$(document).on('page:load', suscribe_search_filter);




