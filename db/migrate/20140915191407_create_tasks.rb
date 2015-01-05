class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :expected_start_date
      t.datetime :expected_end_date
      t.integer :level
      t.integer :state, default: 0
      t.text :description
      t.boolean :deleted
      t.boolean :urgent
      t.decimal :resources_cost, default: 0.0
      t.integer :map_uid

      t.belongs_to :parent, index: true
      t.belongs_to :project, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
