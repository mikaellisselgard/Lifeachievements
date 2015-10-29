class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.text :description
      t.integer :score

      t.timestamps null: false
    end
  end
end
