class AddCostToProject < ActiveRecord::Migration
  def change
    add_column :projects, :cost, :float
  end
end
