class UsersController < ApplicationController
  load_and_authorize_resource

  #manda los proyectos y el usuario que se quiere asignar a proyectos a la vista assign
  def assign
    @projects = Project.all
    @user = User.find(params[:id])
  end

  #asigna el usuario a los proyectos que se marcaron en los checkbox
  #designa a los que no estan marcados
  def assign_to_project
    #se obtiene el usuario en cuestion
    @user = User.find(params[:id])

    #se eliminan todos los proyectos asignados a ese usuario
    #(para posteriormente asignarle todos los que estan marcados)
    @user.projects.clear

    #si el usuario al que se le esta asignando o desasignado proyectos es el super_admin
    if @user.role == "super_admin"
      #se le asignan todos los proyectos
      @user.projects << Project.all
      #sino
    else
      #para cada checkbox
      params['tag'].each do |id_project, tag_value|
        @project = Project.find(id_project)
        #si la checkbox esta marcada, se asigna el proyecto
        if tag_value == "1"
          @user.projects << @project
        end
      end
    end
    redirect_to users_path
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all.includes(:projects)
  end

  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end



  def create
    #se crea el objeto usuario asignandole los parametros recibidos del form.
    project_id = params[:user][:project_id]
    @user = User.new(user_params)
    # Si es creado desde un proyecto en particular, entonces se le asigna ese proyecto
    assign_project(project_id)
    @user.name = @user.name.camelize
    respond_to do |format|
      if @user.save
        format.html { redirect_to :back }
        format.json { render :show, status: :created, location: '/users' }
      else
        format.html { render 'new' } ## Specify the format in which you are rendering "new" page
        format.json { render json: @user.errors }
      end
    end
  end

  def show
    @users = User.all
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    if @user.present?
      @user.destroy

      respond_to do |format|
        format.html { redirect_to :back }
        format.json { head :no_content }
      end
    end
  end

  def update

    # required for settings form to submit when password is left blank
    if user_params[:password].blank?
      params[:user].delete(:password)
    end
    @user = User.find(params[:id])
    #Creo un nuevo hash para guardar el nombre con mayuscula
    new_user_params = user_params
    new_user_params[:name] = user_params[:name].camelize
    respond_to do |format|
      if @user.update(new_user_params)

        #para que no se salga de la cuenta cuando se edita la propia contraseña
        #sign_in(super_admin, :bypass => true)
        format.html { redirect_to :back }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end

  private
  def assign_project(project_id)
    if project_id
    @user.projects << Project.find(project_id)
    end
  end


end