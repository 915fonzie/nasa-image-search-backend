class CreateHrefs < ActiveRecord::Migration[6.0]
  def change
    create_table :hrefs do |t|
      t.string :image_size_url
      t.integer :nasa_id

      t.timestamps
    end
  end
end
