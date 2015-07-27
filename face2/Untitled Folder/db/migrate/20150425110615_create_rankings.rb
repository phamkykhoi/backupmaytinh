class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.string :type
      t.datetime :starts_displaying_at
      t.datetime :ends_displaying_at
      t.references :m_ranking_type, index: true
      t.references :m_genre, index: true
      t.string :top_ranker_name
      t.string :range
      t.text :ranker_photos

      t.timestamps
    end

    add_index :rankings, :ends_displaying_at
    add_index :rankings, :type
  end
end
