class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.belongs_to :project, index: true
      t.belongs_to :user, index: true
      t.integer :role

      t.timestamps
    end
  end
end
