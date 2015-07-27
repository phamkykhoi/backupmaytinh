class CreateMRankingTypes < ActiveRecord::Migration
  def change
    create_table :m_ranking_types do |t|
      t.string :name
      t.integer :order

      t.timestamps
    end
  end
end
