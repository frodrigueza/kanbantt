class AddInputUrlToProject < ActiveRecord::Migration
  def change
  	add_column :projects, :input_url, :string
  end
end
