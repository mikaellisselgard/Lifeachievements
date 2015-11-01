class CreateMedals < ActiveRecord::Migration
  def change
    create_table :medals do |t|
      t.string :type
      t.string :image
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
