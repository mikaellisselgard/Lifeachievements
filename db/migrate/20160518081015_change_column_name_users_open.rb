class ChangeColumnNameUsersOpen < ActiveRecord::Migration
  def change
  	rename_column :users, :open, :hide
  end
end
