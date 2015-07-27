class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.references :user, index: true
      t.integer :max_count
      t.integer :over_count
      t.integer :recover_time
      t.datetime :recovers_all_at

      t.timestamps
    end
  end
end
