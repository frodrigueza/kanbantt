class ProjectsController < ApplicationController
  load_and_authorize_resource

  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end


  # POST /projects
  # POST /projects.json

  def create
    #Si tiene un archivo e input entonces
    if params[:project][:xml_file]
      @project_data = Project.new(project_params)
      file_upload = params[:project][:xml_file]
      # El path donde se va a guardar el archivo
      Dir.mkdir 'public/uploads' unless File.directory?('public/uploads')
      upload_path = Rails.root.join('public', 'uploads', file_upload.original_filename)
      # Si ya existe un archivo con el mismo nombre se crea con un número (i)
      if File.exist? upload_path.to_s
        i=1
        path = upload_path.to_s.insert(-4, "(#{i.to_s})")
        while File.exist? path do
          i = i+1
        end
        name = file_upload.original_filename.insert(-5, "(#{i.to_s})")
        upload_path = Rails.root.join('public', 'uploads', name)
      end
      # Se crea el archivo en el path
      File.open(upload_path, 'wb') do |file|
        file.write(file_upload.read)
      end
      i = Importer.new(params[:project][:xml_file].path(), upload_path.to_s)
      proyecto = i.import
      current_user.projects << proyecto

      #Si se seleccionan valores al crear el proyecto, se guardan.
        #Se guarda el nombre      
        if @project_data.name
          proyecto.update_columns(:name => @project_data.name)
        end

        @project.users << current_user
        #Si tiene recursos, se guarda el atributo.
        if @project_data.resources
            proyecto.update_columns(:resources => @project_data.resources)
          #Si tiene recursos se guarda también el tipo de recursos
          if @project_data.type_resources
            proyecto.update_columns(:type_resources => @project_data.type_resources)
          end
          #Si tiene recursos se guarda si se reporta o no.
          if @project_data.report
            proyecto.update_columns(:report => @project_data.report)
          end
        end
        

      redirect_to projects_path

    else
      @project = Project.new(project_params)

      respond_to do |format|
        if @project.save
          # @project.calculate_progresses
          #buscamos al (o los) super_admin
          @user = User.where(:role => "super_admin")

          #le(s) asignamos el proyecto recien creado
          @user.each do |user|
            user.projects << @project
          end
          format.html { redirect_to :back }
          format.json { render :show, status: :created, location: @project }
        else
          format.html { render :new }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end
  end


  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    #cuando se borra un proyecto borrar también el archivo xml
    if @project.xml_file and File.exist?(@project.xml_file)
      File.delete(@project.xml_file)
    end
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  # metodo asociado a la vista de arbol de un proyecto y sus tareas
  def tree_view
    @project = Project.find(params[:project_id])

    respond_to do |format|
      format.html
      format.js
    end

  end

  # Metodo asociado a la vista de la carta gantt de un proyecto
  def gantt
    @project = Project.find(params[:project_id])
  end

  # Metodo asociado a la vista de indicadores de un proyecto
  def indicators
    @project = Project.find(params[:project_id])
  end

  def export
    project = Project.find(params[:project_id])
    e = Exporter.new(project)
    begin
      hash = e.export
      path = "#{project.name.gsub(' ', '_').camelize}.xml"
      f = File.open(path, "w")
      p "Writing file.."
      f.write(hash["Project"].to_xml(:root => 'Project', skip_types: true))
      send_file(f, disposition:'attachment')
      f.close
      p "File ready!"
    rescue
      flash[:alert] = "No se pudo exportar."
      redirect_to project_path(project)
    end
  end

  def add_tree_view_column
    # tarea de la cual se desplegaran sus hijos en una nueva columna del arbol
    @task = Task.find(params[:parent_id])
    @project = Project.find(params[:project_id])
    respond_to do |format|
      format.js
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:name, :start_date, :end_date, :progress,
                                    :deleted, :xml_file, :resources, :type_resources, :report,
                                    task_attributes: [:id, :name, :expected_start_date, :expected_end_date,
                                                       :start_date, :end_date, :parent_id, :level, :man_hours, :progress, :duration,
                                                       :description, :deleted, :project_id, :resources])
  end


end
