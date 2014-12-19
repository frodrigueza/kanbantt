class CreatePushes < ActiveRecord::Migration
  def change
    create_table :pushes do |t|
      t.string :mail
      t.string :token

      t.timestamps
    end
  end
end
