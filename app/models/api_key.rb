class ApiKey < ActiveRecord::Base
	before_create :generate_access_token
	belongs_to :user, foreign_key: 'user_id'

	#Método que verifica si el token es válido (true) o
	# si ya expiro (false)
	def valid_token
		expire_date >= Time.now
	end
	
	private
	# Método que genera access_token
	def generate_access_token
  		begin
    		self.access_token = SecureRandom.hex
  	end while self.class.exists?(access_token: access_token)
	end

end
