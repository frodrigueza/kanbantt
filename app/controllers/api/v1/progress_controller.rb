#Aquí definimos las respuestas a las llamadas de la api
module Api
  module V1
    class ProgressController < ActionController::Base
      #Con esto definimos como queremos entregar la respuesta.
      respond_to :json

      def estimated_in_resources_by_week
        pc = ProgressCalculator.new(project)
        @array = pc.expected_in_resources
        render :file => "api/v1/progresses/array.json.jbuilder",
               :content_type => 'application/json'
      end

      def real_in_resources_by_week
        pc = ProgressCalculator.new(project)
        @array = pc.real_in_resources
        render :file => "api/v1/progresses/array.json.jbuilder",
               :content_type => 'application/json'
      end

      def estimated_in_days_by_week
        pc = ProgressCalculator.new(project)
        @array = pc.expected_in_days
        render :file => "api/v1/progresses/array.json.jbuilder",
               :content_type => 'application/json'
      end

      def real_in_days_by_week
        pc = ProgressCalculator.new(project)
        @array = pc.real_in_days
        render :file => "api/v1/progresses/array.json.jbuilder",
               :content_type => 'application/json'
      end

      #expected performance
      def performance_estimated_by_week
        pc = ProgressCalculator.new(project)
        @array = pc.expected_in_report
        render :file => "api/v1/progresses/array.json.jbuilder",
               :content_type => 'application/json'
      end

      #real performance
      def performance_real_by_week
        pc = ProgressCalculator.new(project)
        @array = pc.real_in_report
        render :file => "api/v1/progresses/array.json.jbuilder",
               :content_type => 'application/json'
      end

      def real_task_in_resources
        progress(true, true)
      end

      def estimated_task_in_resources
        progress(false, true)
      end

      def real_task_in_days
        progress(true, false)
      end

      def estimated_task_in_days
        progress(false, false)
      end

      def all_progress
        pc = ProgressCalculator.new(project)
        @array = pc.progress_by_task
        @id = project.id
        @project_expected = project.estimated_days_progress_today
        @project_real = project.real_days_progress_today
        render :file => "api/v1/progresses/project.json.jbuilder",
               :content_type => 'application/json'
      end

      private
      def project
        @project ||= Project.find(params[:project_id])
      end

      # Método para calcular progreso según los parámetros entregados
      def progress(is_real, in_resources)
        task = Task.find(params[:task_id])
        pc = ProgressCalculator.new(project)
        if in_resources and is_real
          @array = pc.real_task_in_resources(task)
        elsif in_resources and !is_real
          @array = pc.expected_task_in_resources(task)
        elsif !in_resources and is_real
          @array = pc.real_task_in_days(task)
        elsif !in_resources and !is_real
          @array = pc.expected_task_in_days(task)
        end
        render :file => "api/v1/progresses/array.json.jbuilder",
               :content_type => 'application/json'
      end

    end
  end
end