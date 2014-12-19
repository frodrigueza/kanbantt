var css_setter = function(){
	// Que la div de contenido este pegada a los horizontals
	$('.contenido').css('top', $('.horizontal_menus').height())
};

css_setter;


$(document).ready(css_setter);
$(document).on('page:load', css_setter);