= README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

== Ruby version

---

== System dependencies

---

== Configuration

---

== Database creation

---

== Database initialization

---

== How to run the test suite

---

== Services (job queues, cache servers, search engines, etc.)

---

== Deployment instructions

---

== API
===Métodos de la API

==== Users Cotroller
- Login
 METHOD POST
 PATH :dominio/api/users/login
 BODY email, password

 Ejemplo
 curl -X POST 'http://localhost:3000/api/users/login' -d "email=arturo@gmail.com" -d "password=grupo4grupo4"

- Logout
 METHOD DELETE 
 PATH :dominio/api/users/logout 
 PARAMETROS: token
 
 Ejemplo 
 curl -X DELETE http://localhost:3000/api/users/logout -H 'Authorization:6a3788e30ffa504c81fd73499932767a'

==== Projects controller
- Proyectos de un usuario ( mobile )
 METHOD GET
 HEADER token
 PATH :dominio/api/projects

 Ejemplo
 curl http://localhost:3000/api/projects -H 'Authorization:c576f0136149a2e2d9127b3901015545'

- Proyectos de un usuario ( web )
 Requiere current_user, es decir tener sesión iniciada con devise
 METHOD GET
 PATH :dominio/api/projects/all
 Ejemplo
 http://localhost:3000/api/projects/all 

==== Tasks controller
- Tareas del proyecto especificado
 METHOD GET
 HEADER token
 PATH :dominio/api/projects/:id_project/tasks

 Ejemplo 
 curl 'http://localhost:3000/api/projects/1/tasks' -H 'Authorization:c576f0136149a2e2d9127b3901015545' 

- Mostrar el detalle de una tarea
 METHOD GET
 PATH :dominio/api/projects/:project_id/tasks/:id

 Ejemplo
 curl 'http://localhost:3000/api/projects/1/tasks/1' 

- Reportar avance

 En caso de que el porcentaje sea 100 se necesita reportar las horas hombres si es que el proyecto requiere horas hombres

 METHOD PUT / PATCH
 PATH :dominio/api/projects/:id_project/tasks/:id_task
 HEADER token
 BODY progress
  man_hours (opcional, se ocupa cuando progress es 100 y el proyecto reuiere horas_hombre)
 
 Ejemplo
 //En este ejemplo man_hours no afectará en nada pues el progreso es 50
 curl -X PUT 'http://localhost:3000/api/projects/1/tasks/2' -H 'Authorization:c576f0136149a2e2d9127b3901015545' -d "progress=50" -d "man_hours=10"

- Crear desde la carta gantt (revisar, no se que parametros recibe)
 METHOD POST
 PATH :dominio/api/projects/:project_id/tasks/update_gantt

 Ejemplo
 curl -X POST 'http://localhost:3000/api/projects/1/tasks/update_gantt'

- Update desde la carta gantt (revisar no se que otros parámetros recibe)
 METHOD PUT
 PATH :dominio/api/projects/:project_id/tasks/:id/update_gantt

 Ejemplo
 curl -X PUT 'http://localhost:3000/api/projects/1/tasks/2/update_gantt'

- Destroy desde la carta gantt (revisar porfavor)
 METHOD DELETE
 PATH :dominio/api/projects/:project_id/tasks/:id/update_gantt

 Ejemplo
 curl -X DELETE 'http://localhost:3000/api/projects/1/tasks/2/update_gantt'

==== Progress controller
- Avance estimado en base a tiempo
 METHOD GET
 PATH :dominio/api/progress/estimated_in_days_by_week
 BODY project_id

 Ejemplo 
 curl 'http://localhost:3000/api/progress/estimated_in_days_by_week' -d "project_id=1"

- Avance real en base a tiempo
 METHOD GET
 PATH :dominio/api/progress/real_in_days_by_week
 BODY project_id

 Ejemplo 
 curl 'http://localhost:3000/api/progress/real_in_days_by_week' -d "project_id=1"

- Avance estimado en base a recursos
 METHOD GET
 PATH :dominio/api/progress/estimated_in_resources_by_week
 BODY project_id

 Ejemplo 
 curl 'http://localhost:3000/api/progress/estimated_in_resources_by_week' -d "project_id=1"

- Avance real en base a recursos
 METHOD GET
 PATH :dominio/api/progress/real_in_resources_by_week
 BODY project_id

 Ejemplo 
 curl 'http://localhost:3000/api/progress/real_in_resources_by_week' -d "project_id=1"

- Performance en base a recursos
 METHOD GET
 PATH :dominio/api/progress/performance_in_resources_by_week
 BODY project_id

 Ejemplo 
 curl 'http://localhost:3000/api/progress/performance_in_resources_by_week' -d "project_id=1"

- Performance in one (no se a que se refiere)
 METHOD GET
 PATH :dominio/api/progress/performance_in_one_by_week
 BODY project_id

 Ejemplo 
 curl 'http://localhost:3000/api/progress/performance_in_one_by_week' -d "project_id=1"
      
- Progreso real y esperado del proyecto en base a días 
 METHOD GET
 PATH :dominio/api/progress/all_progress
 BODY project_id

 Ejemplo 
 curl 'http://localhost:3000/api/progress/all_progress' -d "project_id=1"
 
==== Lock controller
- Obtener todos los bloqueos
 METHOD GET
 PATH :dominio/api/locks/all

 Ejemplo
 curl 'http://localhost:3000/api/locks/all'

==== Comment controller
- Crear comentario de una tarea
 METHOD POST
 PATH :dominio/api/projects/:project_id/tasks/:task_id/comments
 HEADER token
 BODY description

 Ejemplo
 curl -X POST 'http://localhost:3000/api/projects/1/tasks/1/comments' -H 'Authorization:c576f0136149a2e2d9127b3901015545' -d "description= hola como estas"
--------------
== Consideraciones a futuro
* Funcionalidades
 1. Integrar default: all para api tasks
 2. Permitir asignación múltiple de tareas, haciendo click en varias a la vez

* Cambios a futuro de diseño
 1. Cambiar el menú lateral, es poco intuitiva la pestaña de administración
 2. Que al apretar la foto del usuario se pueda editar el usuario de la tarea 

--------------


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.