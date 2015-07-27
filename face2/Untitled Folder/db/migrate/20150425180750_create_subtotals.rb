class CreateSubtotals < ActiveRecord::Migration
  def change
    create_table :subtotals do |t|
      t.string :type
      t.references :ranking, index: true
      t.references :user, index: true
      t.integer :rank
      t.integer :supporters_count
      t.integer :supportings_count
      t.text :supporter_photos
      t.datetime :targeted_at

      t.timestamps
    end

    add_index :subtotals, :rank
    add_index :subtotals, :type
    add_index :subtotals, :targeted_at
  end
end
