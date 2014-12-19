class AddMppUidToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :mpp_uid, :integer
  end
end
