class RemovePausedAtFromAssignments < ActiveRecord::Migration
  def up
    remove_column :assignments, :paused_at
  end

  def down
    add_column :assignments, :paused_at, :datetime
  end
end
