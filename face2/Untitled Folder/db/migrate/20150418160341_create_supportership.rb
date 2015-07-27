class CreateSupportership < ActiveRecord::Migration
  def change
    create_table(:supporterships) do |t|
      t.references :post, index: true
      t.references :supporter, index: true
      t.references :supportee, index: true
      t.references :m_genre, index: true
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :supporterships, :deleted_at
    add_index :supporterships, :updated_at
  end
end
