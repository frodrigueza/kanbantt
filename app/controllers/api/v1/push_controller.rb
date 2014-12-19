#Aquí definimos las respuestas a las llamadas de la api
module Api
  module V1
    class PushController < ActionController::Base
      #Con esto definimos como queremos entregar la respuesta.
      respond_to :json

      def all

      end
      
      def send_token
        mail=params[:mail]
        token=params[:token]
        if params.has_key?(:mail) && params.has_key?(:token)
          user=Push.exists?(:token => token)
          if(!user)
            Push.create(:mail => mail, :token => token)
          end
        end

        render nothing: :true, status: 200
      end

    end
  end
end