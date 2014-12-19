class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.belongs_to :task, index: true
      t.decimal :progress
      t.datetime :date

      t.timestamps
    end
  end
end
