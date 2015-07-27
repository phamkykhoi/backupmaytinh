class CreateMGenre < ActiveRecord::Migration
  def change
    create_table(:m_genres) do |t|
      t.string :name

      t.timestamps
    end
  end
end
