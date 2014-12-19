class RenameInputUrlFromProject < ActiveRecord::Migration
  def change
  	rename_column :projects, :input_url, :xml_file
  end
end
