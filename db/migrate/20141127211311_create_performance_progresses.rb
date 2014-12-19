class CreatePerformanceProgresses < ActiveRecord::Migration
  def change
    create_table :performance_progresses do |t|
      t.date :date, index: true
      t.integer :expected
      t.integer :real
      t.belongs_to :project, index: true

      t.timestamps
    end
  end
end
