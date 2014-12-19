// Este archivo implementa la funcionalidad de que si a un elemento HTML le ponemos class="option" y un id="option_1" por ejemplo
// cada vez que se haga click sobre el, se escondera o se mostrará el elemento HTML con id="div_option_1"
// sirve mucho para elementos que inicialmente no se quieren mostrar en el DOM
var suscribe_options = function(){

	// Cada vez que se haga click en un elemento con class="otion"
	$('.option').click(function(){

		// escondemos todos los contenidos asociados a estas opciones
		$('.content_' + this.id.split('_')[0]).hide();
		
		// mostramos el contenido asociado
		$('#content_' + this.id).show();
	});
}

$(function(){
	// cada vez que se cargue la pagina se harán las suscripciones a eventos
	suscribe_options;
});
suscribe_options;