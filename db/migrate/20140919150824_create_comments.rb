class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :task, index: true
      t.belongs_to :project, index: true
      t.belongs_to :enterprise
      t.belongs_to :user
      t.string :description

      t.timestamps
    end
  end
end
