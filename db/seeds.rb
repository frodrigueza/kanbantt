# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


u1 = User.create!(email: 'arturo@gmail.com', password: 'grupo4grupo4',  name: 'Arturo', last_name: 'Campos', super_admin: true)
copec = Enterprise.create(name:'Copec')

# u2 = User.create!(email: 'francisca@gmail.com', password: 'grupo4grupo4',  name: 'Francisca Rojas', role: 'admin')
# u3 = User.create!(email: 'felix@gmail.com', password: 'grupo4grupo4',  name: 'Felix Gonzalez', role: 'last_planner')
# u4 = User.create!(email: 'luis@gmail.com', password: 'grupo4grupo4',  name: 'Luis Rios', role: 'last_planner')
# u5 = User.create!(email: 'camila@gmail.com', password: 'grupo4grupo4',  name: 'Camila Cabello', role: 'last_planner')
# u6 = User.create!(email: 'felipe@gmail.com', password: 'grupo4grupo4',  name: 'Felipe Saavedra', role: 'last_planner')
# u7 = User.create!(email: 'diego@gmail.com', password: 'grupo4grupo4',  name: 'Diego Martinez', role: 'last_planner')


# p1 = Project.create(name: "Edificio Alcantara", start_date: Time.new(2014, 7, 25), end_date: Time.new(2014, 12, 30) )
# p2 = Project.create(name: "Edificio Miramar", start_date: Time.new(2014, 9, 12), end_date: Time.new(2016, 02, 05))
# p3 = Project.create(name: "Edificio Carrera", start_date: Time.new(2013, 10, 01), end_date: Time.new(2015, 04, 31))

# t1 = Task.create(name: "Demoliciones", expected_start_date: Time.new(2014, 7, 25, 12), expected_end_date: Time.new(2014, 8, 10, 12), start_date: Time.new(2014, 7, 25,12), end_date: Time.new(2015, 8, 15, 12), project_id: '1', user_id: '1', resources_cost: '0', duration:'15')#costo real: 350
# 	t11 = Task.create(name: "Cierres", expected_start_date: Time.new(2014, 7, 25, 12), expected_end_date: Time.new(2014, 8, 1, 12), start_date: Time.new(2014, 7, 25,12), end_date: Time.new(2015, 8, 2, 12), project_id: '1', user_id: '1', resources_cost: '100', duration:'4')
# 	t12 = Task.create(name: "Retiros", expected_start_date: Time.new(2014, 8, 2, 12), expected_end_date: Time.new(2014, 8, 10, 12), start_date: Time.new(2014, 8, 2,12), end_date: Time.new(2015, 8, 15, 12), project_id: '1', user_id: '1', resources_cost: '250', duration:'15', duration:'6')
# t2 = Task.create(name: "Excavaciones", expected_start_date: Time.new(2014, 7, 25, 12), expected_end_date: Time.new(2014, 8, 29, 12), start_date: Time.new(2014, 7, 28, 12), end_date: Time.new(2015, 9, 15, 12), project_id: '1', user_id: '1', resources_cost: '0', duration:'30')#costo real: 1650
# 	t21 = Task.create(name: "Fundiciones", expected_start_date: Time.new(2014, 7, 25, 12), expected_end_date: Time.new(2014, 8, 10, 12), start_date: Time.new(2014, 7, 28, 12), end_date: Time.new(2015, 8, 15, 12), project_id: '1', user_id: '1', resources_cost: '0', duration:'10')#costo real: 1450
# 		t211 = Task.create(name: "Excavar", expected_start_date: Time.new(2014, 7, 25, 12), expected_end_date: Time.new(2014, 7, 30, 12), start_date: Time.new(2014, 7, 28, 12), end_date: Time.new(2015, 8, 2, 12), project_id: '1', user_id: '1', resources_cost: '400', duration:'2')
# 		t212 = Task.create(name: "Emplatilado", expected_start_date: Time.new(2014, 7, 30, 12), expected_end_date: Time.new(2014, 8, 7, 12), start_date: Time.new(2014, 8, 2, 12), end_date: Time.new(2015, 8, 10, 12), project_id: '1', user_id: '1', resources_cost: '300', duration:'5')
# 		t213 = Task.create(name: "Hormigon", expected_start_date: Time.new(2014, 8, 7, 12), expected_end_date: Time.new(2014, 8, 10, 12), start_date: Time.new(2014, 8, 10, 12), end_date: Time.new(2015, 8, 15, 12), project_id: '1', user_id: '1', resources_cost: '750', duration:'3')
# 	t22 = Task.create(name: "Enfierradura", expected_start_date: Time.new(2014, 8, 10, 12), expected_end_date: Time.new(2014, 8, 29, 12), start_date: Time.new(2014, 8, 15, 12), end_date: Time.new(2015, 9, 15, 12), project_id: '1', user_id: '1', resources_cost: '200', duration:'18')
# t3 = Task.create(name: "Primer piso", expected_start_date: Time.new(2014, 8, 30, 12), expected_end_date: Time.new(2014, 10, 05, 12), start_date: Time.new(2014, 9, 16, 12), project_id: '1', user_id: '1', resources_cost: '0', duration:'10')#costo real: 2900
# 	t31 = Task.create(name: "Pilares", expected_start_date: Time.new(2014, 8, 30, 12), expected_end_date: Time.new(2014, 10, 05, 12), start_date: Time.new(2014, 9, 16, 12), project_id: '1', user_id: '1', resources_cost: '0', duration:'12')#costo real: 1500
# 		t311 = Task.create(name: "Moldaje", expected_start_date: Time.new(2014, 8, 30, 12), expected_end_date: Time.new(2014, 9, 9, 12), start_date: Time.new(2014, 9, 16, 12), end_date: Time.new(2015, 9, 25, 12), project_id: '1', user_id: '1', resources_cost: '1000', duration:'4')		
# 		t312 = Task.create(name: "Hormigon", expected_start_date: Time.new(2014, 9, 9, 12), expected_end_date: Time.new(2014, 9, 16, 12), start_date: Time.new(2014, 9, 20, 12), end_date: Time.new(2015, 9, 28, 12), project_id: '1', user_id: '1', resources_cost: '500', duration:'15', duration:'5')	
# 	t32 = Task.create(name: "Losas", expected_start_date: Time.new(2014, 9, 17, 12), expected_end_date: Time.new(2014, 10, 05, 12), start_date: Time.new(2014, 9, 28, 12), project_id: '1', user_id: '1', resources_cost: '0', duration:'3')	#costo real: 1400	
# 		t321 = Task.create(name: "Enfierradura", expected_start_date: Time.new(2014, 9, 17, 12), expected_end_date: Time.new(2014, 9, 25, 12), start_date: Time.new(2014, 9, 29, 12), project_id: '1', user_id: '1', resources_cost: '400', duration:'15')
# 		t322 = Task.create(name: "Hormigon", expected_start_date: Time.new(2014, 9, 20, 12), expected_end_date: Time.new(2014, 10, 05, 12), start_date: Time.new(2014, 10, 1, 12), project_id: '1', user_id: '1', resources_cost: '1000', duration:'2')
# t4 = Task.create(name: "Segundo Piso", expected_start_date: Time.new(2014, 10, 06, 12), expected_end_date: Time.new(2014, 10, 30, 12), project_id: '1', user_id: '1', resources_cost: '0', duration:'15')#costo real: 950
# 	t41 = Task.create(name: "Pilares", expected_start_date: Time.new(2014, 10, 06, 12), expected_end_date: Time.new(2014, 10, 18, 12), start_date: Time.new(2014, 10, 30, 12), project_id: '1', user_id: '1', resources_cost: '0', duration:'5')#costo real: 450
# 		t411 = Task.create(name: "Moldaje", expected_start_date: Time.new(2014, 10, 06, 12), expected_end_date: Time.new(2014, 10, 10, 12), start_date: Time.new(2014, 10, 30, 12), project_id: '1', user_id: '1', resources_cost: '100', duration:'5')
# 		t412 = Task.create(name: "Hormigon", expected_start_date: Time.new(2014, 10, 11, 12), expected_end_date: Time.new(2014, 10, 18, 12), project_id: '1', user_id: '1', resources_cost: '350', duration:'4')
# 	t42 = Task.create(name: "Losas", expected_start_date: Time.new(2014, 10, 18, 12), expected_end_date: Time.new(2014, 10, 30, 12), project_id: '1', user_id: '1', resources_cost: '0', duration:'10')#costo real: 500
# 		t421 = Task.create(name: "Moldaje", expected_start_date: Time.new(2014, 10, 18, 12), expected_end_date: Time.new(2014, 10, 22, 12), project_id: '1', user_id: '1', resources_cost: '50', duration:'2')
# 		t422 = Task.create(name: "Hormigon", expected_start_date: Time.new(2014, 10, 23, 12), expected_end_date: Time.new(2014, 10, 30, 12), project_id: '1', user_id: '1', resources_cost: '450', duration:'4')
# t5 = Task.create(name: "Tercer Piso", expected_start_date: Time.new(2014, 11, 01, 12), expected_end_date: Time.new(2014, 11, 26, 12), project_id: '1', user_id: '1', resources_cost: '3000', duration:'14')
# t6 = Task.create(name: "Cuarto Pisto", expected_start_date: Time.new(2014, 11, 26, 12), expected_end_date: Time.new(2014, 12, 20, 12), project_id: '1', user_id: '1', resources_cost: '2800', duration:'22')
# r11_1 = Report.new(task_id:t11.id, progress:20)
# r11_1.created_at = "2014-07-28 11:00:00"
# t11.reports << r11_1
# r11_2 = Report.new(task_id:t11.id, progress:100)
# r11_2.created_at = "2014-08-04 11:00:00"
# t11.reports << r11_2

# r12_1 = Report.new(task_id:t12.id, progress:30)
# r12_1.created_at = "2014-08-15 11:00:00"
# t12.reports << r12_1
# r12_2 = Report.new(task_id:t12.id, progress:100)
# r12_2.created_at = "2014-08-23 11:00:00"
# t12.reports << r12_2

# r211_1 = Report.new(task_id:t211.id, progress:30)
# r211_1.created_at = "2014-07-27 11:00:00"
# t211.reports << r211_1
# r211_2 = Report.new(task_id:t211.id, progress:100)
# r211_2.created_at = "2014-08-10 11:00:00"
# t211.reports << r211_2

# r212_1 = Report.new(task_id:t212.id, progress:60)
# r212_1.created_at = "2014-08-03 11:00:00"
# t212.reports << r212_1
# r212_2 = Report.new(task_id:t212.id, progress:100)
# r212_2.created_at = "2014-08-27 11:00:00"
# t212.reports << r212_2

# r213_1 = Report.new(task_id:t213.id, progress:100)
# r213_1.created_at = "2014-08-29 11:00:00"
# t213.reports << r213_1

# r22_1 = Report.new(task_id:t22.id, progress:10)
# r22_1.created_at = "2014-09-01 11:00:00"
# t22.reports << r22_1
# r22_2 = Report.new(task_id:t22.id, progress:30)
# r22_2.created_at = "2014-09-10 11:00:00"
# t22.reports << r22_2
# r22_3 = Report.new(task_id:t22.id, progress:100)
# r22_3.created_at = "2014-09-23 11:00:00"
# t22.reports << r22_3

# r311_1 = Report.new(task_id:t311.id, progress:60)
# r311_1.created_at = "2014-09-20 11:00:00"
# t311.reports << r311_1
# r311_2 = Report.new(task_id:t311.id, progress:100)
# r311_2.created_at = "2014-10-03 11:00:00"
# t311.reports << r311_2

# r312_1 = Report.new(task_id:t312.id, progress:60)
# r312_1.created_at = "2014-09-25 11:00:00"
# t312.reports << r312_1
# r312_2 = Report.new(task_id:t312.id, progress:100)
# r312_2.created_at = "2014-10-02 11:00:00"
# t312.reports << r312_2

# r321_1 = Report.new(task_id:t321.id, progress:80)
# r321_1.created_at = "2014-10-10 11:00:00"
# t321.reports << r321_1

# t322.reports << Report.new(task_id:t322.id, progress:30)

# t411.reports << Report.new(task_id:t411.id, progress:20)

# Lock.create(locker_id: t11.id, locked_id: t3.id)
# Lock.create(locker_id: t322.id, locked_id: t41.id)

# u1.projects << p1
# u1.projects << p2
# u1.projects << p3
# u2.projects << p1
# u3.projects << p1
# u4.projects << p1
# u5.projects << p1
# u6.projects << p1
# u7.projects << p2
# t1.children << t11
# t1.children << t12
# t2.children << t21
# t21.children << t211
# t21.children << t212
# t21.children << t213
# t2.children << t22
# t3.children << t31
# t3.children << t32
# t31.children << t311
# t31.children << t312
# t32.children << t321
# t32.children << t322
# t4.children << t41
# t4.children << t42
# t41.children << t411
# t41.children << t412
# t42.children << t421
# t42.children << t422

# # Tareas con recursos
# #tr1 = Task.create(name:'thija1', resources_cost: 3000, expected_start_date: Time.new(2014, 10, 6, 12), expected_end_date: Time.new(2014, 10, 16, 12), project_id: 2)
# #tr2 = Task.create(name:'thija2', resources_cost: 7000, expected_start_date: Time.new(2014, 10, 5, 12), expected_end_date: Time.new(2014, 10, 19, 12), project_id: 2)
# #tr3 = Task.create(name:'thija3', resources_cost: 2000, expected_start_date: Time.new(2014, 10, 2, 12), expected_end_date: Time.new(2014, 10, 14, 12), project_id: 2)


# Task.all.each do |t|
# 	t.set_level
# end
