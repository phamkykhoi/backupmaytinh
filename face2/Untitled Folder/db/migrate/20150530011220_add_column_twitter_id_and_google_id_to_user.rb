class AddColumnTwitterIdAndGoogleIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :google_id, :string
    add_column :users, :twitter_id, :string

    add_index :users, :google_id
    add_index :users, :twitter_id
  end
end
