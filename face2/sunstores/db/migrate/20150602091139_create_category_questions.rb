class CreateCategoryQuestions < ActiveRecord::Migration
  def change
    create_table :category_questions do |t|
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
