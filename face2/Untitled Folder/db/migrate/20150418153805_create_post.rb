class CreatePost < ActiveRecord::Migration
  def change
    create_table(:posts) do |t|
      t.references :user, index: true
      t.references :m_genre, index: true
      t.integer :supporters_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.integer :bans_count, null: false, default: 0
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :posts, :deleted_at
    add_index :posts, :updated_at
    add_index :posts, :comments_count
    add_index :posts, :supporters_count
  end
end
