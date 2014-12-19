#Aquí definimos las respuestas a las llamadas de la api
module Api
  module V1
    class ProjectsController < ActionController::Base
      before_filter :restrict_access, only: [:index]
      before_action :set_user, only: [:index]
      #Con esto definimos como queremos entregar la respuesta.
      respond_to :json

      def index
        @projects = @user.projects
        respond_with @projects
      end


      def all
        @projects = User.find(current_user).projects
        render :file => "api/v1/projects/all.json.jbuilder",
               :content_type => 'application/json'
      end


      private
       def restrict_access
        token=request.headers["Authorization"]
        set_api_key(token)
        if @ak
          unless @ak.valid_token
            @ak.destroy
          end
        end
        unless ApiKey.exists?(access_token: token)
          render nothing: 'HTTP_ACCESS_DENIED', status: '403'
        end
      end

      def set_user
        token = request.headers["Authorization"]
        set_api_key(token)
        @user = @ak.user if @ak
      end

      def set_api_key(token)
        @ak = ApiKey.find_by_access_token(token)
      end
    end
  end
end
