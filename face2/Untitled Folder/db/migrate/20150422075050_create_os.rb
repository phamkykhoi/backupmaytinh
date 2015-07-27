class CreateOs < ActiveRecord::Migration
  def change
    create_table :os do |t|
      t.references :user, index: true
      t.string :device_token
      t.string :registration_id
      t.string :type

      t.timestamps
    end
  end
end
