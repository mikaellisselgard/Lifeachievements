class CreateSearchResults < ActiveRecord::Migration
  def change
    create_table :search_results do |t|
      t.string :record_string
      t.string :record_type
      t.integer :record_id

      t.timestamps null: false
    end
  end
end
