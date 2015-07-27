class AddIndexPostsCountToUser < ActiveRecord::Migration
  def change
    add_index :users, :posts_count
  end
end
