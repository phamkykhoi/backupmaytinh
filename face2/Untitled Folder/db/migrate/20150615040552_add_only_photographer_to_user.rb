class AddOnlyPhotographerToUser < ActiveRecord::Migration
  def change
    add_column :users, :only_photographer, :boolean
  end
end
