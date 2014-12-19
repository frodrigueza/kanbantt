######API#######
require 'api_constraints'

Rails.application.routes.draw do
  resources :resources_reports

  #Aquí creamos rutas para proveer la API de la aplcación, para ver más detalles acceder a:
    # http://railscasts.com/episodes/350-rest-api-versioning?view=asciicast
  namespace :api, defaults: {format: 'json'} do

    #Archivos relevantes para la API
    ## /lib/api_constraints
    ## /app/controllers/api  (todo lo que esta dentro de esa carpeta)

    # Para la version 1 tenemos este bloque con api constraints especificamos la versión
    # y si es que esta es la que se ocupa por default
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      #Aquí defeinimos las rutas que queremos proveer
      #por ahora tenemos disponibles los proyectos, tareas y login de usuario
      get '/locks/all' => 'locks#all'
      resources :projects, only: [:index] do
        resources :tasks, only: [:index,:update,:show] do
          get 'all', on: :collection
          put 'update_gantt', on: :member, action:'update_gantt'
          delete 'update_gantt', on: :member, action:'destroy'
          post 'update_gantt', on: :collection, action:'create'
          resources :comments, only: [:create]
        end
        get 'all', on: :collection
      end

      #Métodos para usuarios
      post 'users/login', to: 'users#login'
      delete 'users/logout', to: 'users#logout'

      #Métodos de progresos
      get '/progress/estimated_in_resources_by_week' 
      get '/progress/real_in_resources_by_week' 
      get '/progress/estimated_in_days_by_week'
      get '/progress/real_in_days_by_week' 
      get '/progress/all_progress'

      get '/progress/performance_in_resources_by_week'
      get '/progress/performance_in_one_by_week'
      post '/push/send_token'

      
      get '/progress/performance_estimated_by_week'
      get '/progress/performance_real_by_week'

    end
  end

#######termino API#####
  
  # Página de errores
  get 'errors/file_not_found'
  get 'errors/unprocessable'
  get 'errors/internal_server_error'
  match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all


  #usuarios con gema devise
  devise_for :users


  #Resources genera todas las rutas CRUD para cada uno de estos objetos
  resources :projects do
    get 'tree_view'
    get 'add_tree_view_column'
    get 'gantt'
    get 'indicators'
    get 'export'
    get 'kanban_board', to: 'kanban_board#index', as: :kanban_board_index
    get 'gantt', to: 'gantt#index'
    post 'kanban_board/update', to: 'kanban_board#update', as: :kanban_board_update
    resources :tasks do
      resources :reports
      resources :comments
      resources :resources_reports
      get 'update_item_partial', to: 'kanban_board#update_item_partial', as: :kanban_board_update_item_partial

    end
  end

  resources :tasks do
    get 'new_child'
    post 'delete_confirmation'
  end

  resources :users do
    get 'assign', on: :member
    post 'assign_to_project', on: :member, action:'assign_to_project'
  end

  get 'gantt', to: 'gantt#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #Esta es la ruta que define donde comienza la aplicación (Home page)
  root 'kanban_board#index'
  
  get 'kanban_board_index', to: 'kanban_board#index'
  get 'gantt', to: 'gantt#index'

  resources :comments
  resources :reports

end
