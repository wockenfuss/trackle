class AddResumedAtToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :resumed_at, :datetime
  end
end
