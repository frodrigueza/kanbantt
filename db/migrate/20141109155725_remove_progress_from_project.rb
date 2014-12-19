class RemoveProgressFromProject < ActiveRecord::Migration
  def change
  	remove_column :projects, :progress
  end
end
