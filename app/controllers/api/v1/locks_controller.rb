#Aquí definimos las respuestas a las llamadas de la api
module Api
  module V1
    class LocksController < ActionController::Base
      #Con esto definimos como queremos entregar la respuesta.
      respond_to :json

      def all
        #@locks = Lock.all
        render :file => "api/v1/locks/all.json.jbuilder", :content_type => 'application/json'
      end

    end
  end
end
