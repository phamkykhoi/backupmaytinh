class CreateRequestToken < ActiveRecord::Migration
  def change
    create_table(:request_tokens) do |t|
      t.references :user, index: true
      t.string :content
      t.datetime :expires_at

      t.timestamps
    end
  end
end
