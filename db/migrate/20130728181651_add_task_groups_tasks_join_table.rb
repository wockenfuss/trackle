class AddTaskGroupsTasksJoinTable < ActiveRecord::Migration
  def change
  	create_table :task_groups_tasks do |t|
  		t.integer :task_id
  		t.integer :task_group_id
  	end
  end
end
