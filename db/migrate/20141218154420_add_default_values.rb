class AddDefaultValues < ActiveRecord::Migration
  	def up
		change_column :projects, :resources, :boolean, default: false
		change_column :projects, :cost, :float, default: 0.0
		change_column :tasks, :resources, :decimal, default: 0.0
		change_column :tasks, :resources_cost, :float, default: 0.0
	end

	def down
	end
end
