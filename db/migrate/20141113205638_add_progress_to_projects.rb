
class AddProgressToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :progress, :decimal, default: 0
  end
end
