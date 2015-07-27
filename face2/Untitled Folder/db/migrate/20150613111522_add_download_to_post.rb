class AddDownloadToPost < ActiveRecord::Migration
  def change
    add_column :posts, :download, :boolean, default: false
    add_column :posts, :camera_id, :integer
    add_column :posts, :location, :string
    add_column :posts, :photographer_id, :integer
  end
end
