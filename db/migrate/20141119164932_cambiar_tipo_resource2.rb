class CambiarTipoResource2 < ActiveRecord::Migration
  def change
  	remove_column :tasks, :resources_cost
  	add_column :tasks, :resources_cost, :float
  end
end
