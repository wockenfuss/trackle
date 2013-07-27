class AddColorToCity < ActiveRecord::Migration
  def change
    add_column :cities, :color, :string
  end
end
