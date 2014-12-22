class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :expected_start_date
      t.datetime :expected_end_date
      t.decimal :progress, default: 0
      t.integer :resources_type, default: 0
      t.decimal :resources, default: 0.0
      t.decimal :resources_cost, default: 0.0
      t.decimal :cost
      t.string :xml_file

      t.boolean :resources_reporting, default: false  

      t.belongs_to :enterprise
      t.timestamps
    end
  end
end
