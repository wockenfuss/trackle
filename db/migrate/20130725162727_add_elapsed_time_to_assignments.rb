class AddElapsedTimeToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :elapsed_time, :integer, :default => 0
  end
end
