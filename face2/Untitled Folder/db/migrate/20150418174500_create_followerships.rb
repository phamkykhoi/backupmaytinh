class CreateFollowerships < ActiveRecord::Migration
  def change
    create_table :followerships do |t|
      t.references :follower, index: true
      t.references :followee, index: true

      t.timestamps
    end

    add_index :followerships, [:follower_id, :followee_id], unique: true
  end
end
