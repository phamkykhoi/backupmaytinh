class CreatePostsTags < ActiveRecord::Migration
  def change
    create_table :posts_tags, id: false do |t|
      t.references :post, index: true, null: false
      t.references :tag, index: true, null: false
    end
  end
end
