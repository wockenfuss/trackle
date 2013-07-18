class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.text :content, :null => false
      t.string :subject, :null => false
      t.references :user, :null => false
      t.datetime :begin_date
      t.datetime :end_date, :null => false

      t.timestamps
    end
  end
end
