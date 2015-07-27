class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :subject_class
      t.string :action
      t.integer :role_id

      t.timestamps null: false
    end
  end
end
