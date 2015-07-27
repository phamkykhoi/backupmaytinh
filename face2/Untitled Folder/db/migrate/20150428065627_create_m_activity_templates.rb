class CreateMActivityTemplates < ActiveRecord::Migration
  def change
    create_table :m_activity_templates do |t|
      t.string :key
      t.text :text

      t.timestamps
    end
  end
end
