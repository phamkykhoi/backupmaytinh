class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :body
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
