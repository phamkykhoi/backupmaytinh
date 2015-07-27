class CreateCreateds < ActiveRecord::Migration
  def change
    create_table :createds do |t|
      t.string :a
      t.string :database
      t.string :migration

      t.timestamps null: false
    end
  end
end
