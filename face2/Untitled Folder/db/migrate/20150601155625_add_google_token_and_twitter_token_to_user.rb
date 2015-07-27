class AddGoogleTokenAndTwitterTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :google_token, :text
    add_column :users, :twitter_token, :text
  end
end
