class CreateEnterprises < ActiveRecord::Migration
  def change
    create_table :enterprises do |t|
      t.text :name
      t.integer :boss_id

      t.timestamps
    end
  end
end
