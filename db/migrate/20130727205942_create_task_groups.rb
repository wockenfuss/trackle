class CreateTaskGroups < ActiveRecord::Migration
  def change
    create_table :task_groups do |t|
      t.string :name, :null => false

      t.timestamps
    end
  end
end
