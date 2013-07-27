class RenameCitiesTableAsProjects < ActiveRecord::Migration
  def change
  	rename_table :cities, :projects
  	rename_column :assignments, :city_id, :project_id
  end
end
