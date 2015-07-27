class RemovePostIdFromBan < ActiveRecord::Migration
  def change
    remove_column :bans, :post_id, :integer
  end
end
