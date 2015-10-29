class CreateBucketLists < ActiveRecord::Migration
  def change
    create_table :bucket_lists do |t|
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
