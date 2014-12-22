class Enterprise < ActiveRecord::Base
	has_many :users, dependent: :destroy
	has_many :projects, dependent: :destroy
	belongs_to :boss, class_name:'User'

	before_create :create_boss
	before_destroy :destroy_boss_acount


	def create_boss
		# creamos un usuario que sera el admin de la empresa. Esta tendra su id como referencia
		self.boss = User.create(name: 'Administrador', last_name: self.name, password:12345678, password_confirmation:12345678, email: 'admin_' + name.downcase + '@kanbantt.cl')
		users << boss
	end

	def destroy_boss_acount
		if boss_id
			boss.destroy
		end
	end
end
