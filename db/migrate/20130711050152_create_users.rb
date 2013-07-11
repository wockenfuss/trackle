class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :null => false
      t.string :email
      t.boolean :available, :default => true
      t.boolean :absent, :default => false

      t.timestamps
    end
  end
end
