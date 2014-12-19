class CreateResourcesReports < ActiveRecord::Migration
  def change
    create_table :resources_reports do |t|
      t.integer :task_id
      t.decimal :resources
      t.integer :user_id

      t.timestamps
    end
  end
end
