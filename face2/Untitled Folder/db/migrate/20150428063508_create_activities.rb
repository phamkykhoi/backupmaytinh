class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :trackable, polymorphic: true
      t.references :user, index: true
      t.text :body

      t.timestamps
    end

    add_index :activities, [:trackable_id, :trackable_type]
  end
end
