class CreateTaskPositions < ActiveRecord::Migration
  def change
    create_table :task_positions do |t|
      t.belongs_to :column, index: true
      t.belongs_to :task, index: true
      t.belongs_to :project, index: true
      t.belongs_to :user, index: true
      t.integer :position

      t.timestamps
    end
  end
end
