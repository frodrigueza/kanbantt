class ChangeTypeToTask < ActiveRecord::Migration
  def change
  	remove_column :tasks, :resources
    add_column :tasks, :resources, :decimal
  end
end
