class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.integer :category_id
      t.integer :user_id
      t.integer :count_correct

      t.timestamps null: false
    end
  end
end
