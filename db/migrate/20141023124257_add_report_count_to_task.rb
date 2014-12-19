class AddReportCountToTask < ActiveRecord::Migration
	def up
    add_column :tasks, :reports_count, :integer, null: false, default: 0
    Task.reset_column_information
    Task.find_each do |task|
    	Task.reset_counters(task.id, :reports)
    end
  end
  def down
	remove_column :tasks, :reports_count
  end
end
