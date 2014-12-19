class AddCounterCacheToTask < ActiveRecord::Migration
  def up
    add_column :tasks, :children_count, :integer, null: false, default: 0
    Task.find_each do |task|
    	Task.reset_counters(task.id, :children)
    end

  end
  def down
	remove_column :tasks, :children_count
  end

end
