class AddAttributesToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :days_cost, :float
    add_column :tasks, :resources_cost, :float
  end
end
