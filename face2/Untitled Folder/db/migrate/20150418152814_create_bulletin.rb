class CreateBulletin < ActiveRecord::Migration
  def change
    create_table(:bulletins) do |t|
      t.text :content

      t.timestamps
    end
  end
end
