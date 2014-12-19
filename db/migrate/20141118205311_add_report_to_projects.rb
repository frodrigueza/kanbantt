class AddReportToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :report, :string
    add_column :projects, :boolean, :string
  end
end
