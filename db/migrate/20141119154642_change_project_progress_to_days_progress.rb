class ChangeProjectProgressToDaysProgress < ActiveRecord::Migration
  def change
    rename_table :project_progresses, :days_progresses
  end 
end
