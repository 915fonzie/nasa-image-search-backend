class CreateUserSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :user_searches do |t|
      t.string :search
      t.integer :nasa_id

      t.timestamps
    end
  end
end
