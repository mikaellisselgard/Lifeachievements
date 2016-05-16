class AddShareGpsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :share_gps, :boolean, default: true
	end
end
