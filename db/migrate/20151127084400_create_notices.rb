class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :message
      t.references :user, index: true, foreign_key: true
      t.datetime :seen

      t.timestamps null: false
    end
  end
end
