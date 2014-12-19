class AddAtributtesToProject < ActiveRecord::Migration
  def change
  	add_column :projects, :resources, :boolean
  	add_column :projects, :report, :boolean
  end
end
