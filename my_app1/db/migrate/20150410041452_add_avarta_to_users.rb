class AddAvartaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avarta, :string
  end
end
