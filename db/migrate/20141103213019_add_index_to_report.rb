class AddIndexToReport < ActiveRecord::Migration
  def change
    add_index :reports, :created_at
  end
end
