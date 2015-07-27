class AddColumnToBan < ActiveRecord::Migration
  def change
    add_column :bans, :reportable_id, :integer
    add_column :bans, :reportable_type, :string
    add_index :bans, [:reportable_id, :reportable_type]
  end
end
