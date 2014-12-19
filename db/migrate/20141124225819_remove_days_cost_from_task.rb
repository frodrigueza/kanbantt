class RemoveDaysCostFromTask < ActiveRecord::Migration
  def change
  	remove_column :tasks, :days_cost
  end
end
