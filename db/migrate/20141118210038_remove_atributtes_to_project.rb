class RemoveAtributtesToProject < ActiveRecord::Migration
  def change
  	remove_column :projects, :report
  	remove_column :projects, :boolean
  end
end
