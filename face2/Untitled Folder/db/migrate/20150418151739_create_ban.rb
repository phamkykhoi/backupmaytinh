class CreateBan < ActiveRecord::Migration
  def change
    create_table(:bans) do |t|
      t.references :user, index: true
      t.references :post, index: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :bans, :deleted_at
  end
end
