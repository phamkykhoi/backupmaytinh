class CreateMVersions < ActiveRecord::Migration
  def change
    create_table :m_versions do |t|
      t.string :required_ios
      t.string :required_android
      t.string :latest_ios
      t.string :latest_android

      t.timestamps
    end
  end
end
