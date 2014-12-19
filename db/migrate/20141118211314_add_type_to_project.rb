class AddTypeToProject < ActiveRecord::Migration
  def change
  	  	add_column :projects, :type_resources, :string
  end
end
