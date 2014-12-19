class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.datetime :expected_start_date
      t.datetime :expected_end_date
      t.datetime :start_date
      t.datetime :end_date
      t.belongs_to :parent, index: true
      t.integer :level
      t.decimal :man_hours, default: 0
      t.decimal :progress, default: 0
      t.string :description
      t.boolean :deleted
      t.belongs_to :project, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
