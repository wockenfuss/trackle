class AddColorToProject < ActiveRecord::Migration
  def change
    add_column :projects, :color, :string
  end
end
