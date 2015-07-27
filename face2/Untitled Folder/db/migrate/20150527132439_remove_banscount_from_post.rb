class RemoveBanscountFromPost < ActiveRecord::Migration
  def change
    remove_column :posts, :bans_count, :integer
  end
end
