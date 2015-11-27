class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :message
      t.datetime :seen

      t.timestamps null: false
    end
  end
end
