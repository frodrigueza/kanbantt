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

                var new_state;
                if (column_id == 'done_kanban_column') 
                {   
                    new_state = 2;
                }
                else if(column_id == 'in_progress_kanban_column')
                {
                    new_state = 1;
                }
                else if(column_id == 'inactive_kanban_column')
                {
                    new_state = 0;
                }
                      
                // actualizamos la task en la base de datos
                $.ajax({
                    url: "/tasks/" + task_id,
                    type: "PUT",
                    data: {
                        task: {
                            state: new_state
                        }
                    }
                });

                // actualizamos la vista del item de la task
                $.ajax({
                    url: "update_item_partial",
                    type: "GET",
                    data: {
                        task_id: task_id
                    }
                });

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



                    //     //Modal que pregunta la cantidad de recursos usados al terminar la tarea
                    //     var id_task = parseInt(ui.item[0].id.split("_")[1]);
                    //     var name = "#reportar" + id_task
                    //     $.unblockUI();
                    //     $(name).modal();

                // Se actualiza el partial del item arrastrado.
                // $.post('kanban_board/update_item_partial');

                // Actualizamos los contadores
                updateCounters();

            }

        // prevenimos la seleccion de texto cuando queramos hacer drag-n-drop
        }).disableSelection(); 
});