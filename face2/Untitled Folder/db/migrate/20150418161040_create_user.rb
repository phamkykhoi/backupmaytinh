class CreateUser < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :name
      t.string :login_id
      t.string :facebook_id
      t.string :profile_photo
      t.text :facebook_token
      t.string :email
      t.string :password_digest
      t.date :birthday
      t.datetime :deleted_at
      t.integer :followers_count, null: false, default: 0
      t.integer :followings_count, null: false, default: 0
      t.integer :supportings_count, null: false, default: 0
      t.integer :posts_count, null: false, default: 0
      t.boolean :ticket_recover_notice, null: true, default: true
      t.boolean :no_login_notice, null: true, default: true
      t.boolean :followee_posts_notice, null: true, default: true
      t.boolean :supported_notice, null: true, default: true
      t.boolean :commented_notice, null: true, default: true
      t.boolean :followed_notice, null: true, default: true
      t.boolean :bulletin_notice, null: true, default: true

      t.timestamps
    end

    add_index :users, :deleted_at
    add_index :users, :email, unique: true
  end
end
