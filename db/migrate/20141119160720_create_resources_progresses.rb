class CreateResourcesProgresses < ActiveRecord::Migration
  def change
    create_table :resources_progresses do |t|
      t.date :date, index: true
      t.float :expected
      t.float :real
      t.belongs_to :project, index: true
      t.timestamps
    end
  end
end
