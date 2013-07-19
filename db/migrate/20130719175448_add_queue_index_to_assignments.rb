class AddQueueIndexToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :queue_index, :integer
  end
end
