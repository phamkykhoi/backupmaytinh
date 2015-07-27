class CreateAppDriverHistories < ActiveRecord::Migration
  def change
    create_table :app_driver_histories do |t|
      t.string :identifier
      t.string :achieve_id
      t.datetime :accepted_time
      t.integer :campaign_id
      t.string :campaign_name
      t.integer :advertisement_id
      t.string :advertisement_name
      t.integer :point
      t.string :payment
      t.references :user, index: true

      t.timestamps
    end

    add_index :app_driver_histories, [:identifier, :advertisement_id]
  end
end
