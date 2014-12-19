class AddResourcesToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :resources, :float
  end
end
