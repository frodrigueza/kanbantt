#Aquí definimos las respuestas a las llamadas de la api
module Api
  module V1

    class CommentsController < ActionController::Base
      before_filter :restrict_access, only: [:create]
      before_action :set_user, only: [:create]
    #Con esto definimos como queremos entregar la respuesta.
    respond_to 'json'



      def create
      @comment = Comment.new(:task_id => params[:task_id], :user_id => @user.id, :description => params[:description])
        if @comment.save
          render nothing: true, status: :created
        end
      end

      # Para restringir acceso el usuario debe entregar el token
      private
      def restrict_access
        token=request.headers["Authorization"]
          ak = ApiKey.where(access_token: token).first
          if ak
            unless ak.valid_token
              ak.destroy
            end
          end
          ApiKey.exists?(access_token: token)
        end


      def set_user
        token = request.headers["Authorization"]
        @user = ApiKey.find_by_access_token(token).user
      end

    end
  end
end