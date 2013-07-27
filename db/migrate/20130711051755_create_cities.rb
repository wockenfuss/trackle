class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, :null => false
      t.datetime :deadline
      t.boolean :hold, :default => false

      t.timestamps
    end
  end
end
