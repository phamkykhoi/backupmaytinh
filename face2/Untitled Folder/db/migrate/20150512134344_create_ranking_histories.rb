class CreateRankingHistories < ActiveRecord::Migration
  def change
    create_table :ranking_histories do |t|
      t.references :user, index: true
      t.integer :daily_1, null: false, default: 0
      t.integer :daily_2, null: false, default: 0
      t.integer :daily_3, null: false, default: 0
      t.integer :monthly_1_3, null: false, default: 0
      t.integer :monthly_4_10, null: false, default: 0
      t.integer :monthly_11_50, null: false, default: 0

      t.timestamps
    end
  end
end
