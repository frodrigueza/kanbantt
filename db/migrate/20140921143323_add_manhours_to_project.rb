class AddManhoursToProject < ActiveRecord::Migration
  def change
    add_column :projects, :expected_start_date, :datetime
    add_column :projects, :expected_end_date, :datetime
  end
end
