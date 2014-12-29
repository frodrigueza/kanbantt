class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
      t.datetime :date
      
      t.decimal :real_days_progress
      t.decimal :expected_days_progress

      t.decimal :real_resources_progress
      t.decimal :expected_resources_progress

      t.decimal :real_used_resources
      t.decimal :expected_used_resources

      t.belongs_to :project
      t.belongs_to :task

      t.timestamps
    end
  end
end
