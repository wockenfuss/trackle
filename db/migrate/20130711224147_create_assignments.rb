class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :duration
      t.datetime :deadline
      t.datetime :started_at
      t.datetime :completed_at
      t.datetime :paused_at
      t.boolean :hold, :default => false
      t.integer :amount_completed, :default => 0
      t.references :user, :null => false
      t.references :task, :null => false
      t.references :project, :null => false

      t.timestamps
    end
  end
end
