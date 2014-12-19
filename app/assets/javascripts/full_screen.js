// Full screen implementado en la vista explorador.
// Lo unico que hace es cambiar la class del elemento class="parte_derecha" y 
// hace que este se sobreponga en toda la pantalla
var full_screen = function(){
	$('.contenido').toggleClass("full_screen");
};

var suscribe_full_screen = function(){
	$('#full_screen_switch').click(function(){
		full_screen();
	});
};



// Suscripciones al cargar la pagina
$(function(){
	suscribe_full_screen;
});

// Suscripciones luego de llegar por un turbolink
$(document).ready(suscribe_full_screen);
$(document).on('page:load', suscribe_full_screen);