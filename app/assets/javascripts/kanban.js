//Esto maneja todo el movimiento de los tasks en el kanban board y se encarga de llamar al método update
// medienta AJAX cuando se cambia una tarea de posición

$(function(){

        $(".sortable_group" ).sortable({
            items: "> .sortable_kanban_item", //Cuales serán los items que se pueden mover
            opacity: 0.7 , //Opacidad al agarrar el objeto
            cursor: "move",
            connectWith: ".sortable_group",
            receive: function (event, ui) {
                
                // id de la tarea movida
                var task_id = ui.item.context.id.split('_')[2];

                // id de la columna donde fue dropeado el item
                column_id = ui.item.closest('.column').attr('id');

                // current_user
                var user_id = $('#current_user_id').text();
                console.log('movido');

                // Si la columna fue la de finalizado se envia un AJAX cambiando el progreso al 100%
                if (column_id == 'done_kanban_column') 
                {

                    // antes de enviar el ajax, debemos consultar los recursos utilizados en esa task
                    var resources = prompt("Ingresa los recursos utilizados en esta task", "100");

                    if (resources != null && $.isNumeric(resources)) 
                    {


                    }   
                        // $.ajax({
                        //     url: "/reports",
                        //     type: "POST",
                        //     data: {
                        //         report: {
                        //              task_id: task_id, 
                        //              user_id: user_id,
                        //              progress: 100 
                        //          }
                        //     }
                        // });
                    else
                    {
                        alert('Debes ingresar un input numérico');
                    }



                    //     //Modal que pregunta la cantidad de recursos usados al terminar la tarea
                    //     var id_task = parseInt(ui.item[0].id.split("_")[1]);
                    //     var name = "#reportar" + id_task
                    //     $.unblockUI();
                    //     $(name).modal();
                };

                // Se actualiza el partial del item arrastrado.
                $.get('tasks/' + task_id + '/update_item_partial');

                // Actualizamos los contadores
                updateCounters();

            }

        // prevenimos la seleccion de texto cuando queramos hacer drag-n-drop
        }).disableSelection(); 
});