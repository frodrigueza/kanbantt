class AddWorkHoursToProject < ActiveRecord::Migration
  def change
    add_column :projects, :work_hours, :integer
  end
end
