class DeleteDateFromReport < ActiveRecord::Migration
  def change
  	remove_column :reports, :date
  end
end
