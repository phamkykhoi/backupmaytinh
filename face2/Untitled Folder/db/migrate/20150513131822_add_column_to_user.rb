class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :comment, :text
  end
end
