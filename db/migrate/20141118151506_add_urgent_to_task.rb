class AddUrgentToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :urgent, :boolean
  end
end
