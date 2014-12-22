class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.decimal :progress
      t.float :resources

      t.belongs_to :task, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
