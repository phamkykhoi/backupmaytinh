class AddFacebookNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_name, :string

    add_index :users, :facebook_name
  end
end
