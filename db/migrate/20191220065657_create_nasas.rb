class CreateNasas < ActiveRecord::Migration[6.0]
  def change
    create_table :nasas do |t|
      t.string :title
      t.text :description
      t.string :photographer
      t.string :location
      t.string :media_type
      t.string :date_created
      t.string :thumb_url

      t.timestamps
    end
  end
end
