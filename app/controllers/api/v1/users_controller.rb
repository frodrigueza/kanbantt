#Aquí definimos las respuestas a las llamadas de la api
module Api
    module V1
        class UsersController < ActionController::Base
            #Con esto definimos como queremos entregar la respuesta.
            respond_to :json

            # Este método retorna el token del usuario y la información necesaria para
            # la aplicación mobile
            def login
            	user = User.where(email: params[:email]).first
                if user
                    if user.valid_password?(params[:password])
                        tok = ApiKey.create!
                        if tok
                            user.api_key << tok
                            user.save
                            tok.user = user
                            tok.expire_date = Time.now + 1.day
                            tok.save
                            render json: {:token=> tok.access_token, :username=> user.name, :role=> user.role, :user_id=> user.id}
                        end
                    else 
                        #Password malo
                        render nothing: :true , status: 401
                    end
                else
                    #Mail malo
                    render nothing: :true, status: 401
                end
            end

            #Este método borra el token que tiene el usuario
            def logout
                token = request.headers["Authorization"]
                set_api_key(token)
                if @ak
                    @ak.destroy
                end
                render nothing: :true, status: 200
            end


            private

            def set_api_key(token)
                @ak = ApiKey.find_by_access_token(token)
            end

        end
    end
end