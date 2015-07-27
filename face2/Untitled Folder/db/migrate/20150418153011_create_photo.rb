class CreatePhoto < ActiveRecord::Migration
  def change
    create_table(:photos) do |t|
      t.references :post, index: true
      t.string :content
      t.text :description
      t.boolean :main
      t.datetime :deleted_at
      t.integer :width_ratio
      t.integer :height_ratio

      t.timestamps
    end

    add_index :photos, :main
    add_index :photos, :deleted_at
  end
end
