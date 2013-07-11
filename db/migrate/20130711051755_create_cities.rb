class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name, :null => false
      t.datetime :deadline
      t.boolean :hold, :default => false

      t.timestamps
    end
  end
end
