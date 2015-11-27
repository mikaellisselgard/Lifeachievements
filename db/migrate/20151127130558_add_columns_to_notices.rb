class AddColumnsToNotices < ActiveRecord::Migration
  def change
    add_column :notices, :user_id, :int
    add_column :notices, :link, :string
  end
end
