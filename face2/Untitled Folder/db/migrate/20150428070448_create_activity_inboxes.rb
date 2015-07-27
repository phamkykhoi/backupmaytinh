class CreateActivityInboxes < ActiveRecord::Migration
  def change
    create_table :activity_inboxes do |t|
      t.references :user, index: true
      t.references :activity, index: true

      t.timestamps
    end

    add_index :activity_inboxes, [:user_id, :activity_id], unique: true
  end
end
