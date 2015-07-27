class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fullname
      t.string :email
      t.boolean :admin
      t.string :avatar
      t.string :password_digest
      t.string :password_confirmation

      t.timestamps null: false
    end
  end
end
