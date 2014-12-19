class CambiarTipoResource < ActiveRecord::Migration
  def change
  	remove_column :tasks, :resources_cost
  	add_column :tasks, :resources_cost, :decimal
  end
end
