var blocks = function(){
	// bloaqueamos el DOM mientras las llamadas de ajax no han sido terminadas
    $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);

    // hay links que se demoran mucho en cambiar. Como los de kanban.
    // $('.slow_link').click(function(){
    // 	$.blockUI();
    // });

};

// Cada vez que se cargue la pagina suscribimos los elementos ajax a este metodo
$(document).ready(blocks);
$(document).on('page:load', blocks);