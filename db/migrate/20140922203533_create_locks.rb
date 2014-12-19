class CreateLocks < ActiveRecord::Migration
  def change
    create_table :locks do |t|
    	t.integer :locker_id, index: true
    	t.integer :locked_id, index: true

      t.timestamps
    end
  end
end
