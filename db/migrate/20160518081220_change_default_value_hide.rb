class ChangeDefaultValueHide < ActiveRecord::Migration
  def change
  	change_column :users, :hide, :boolean, default: false
  end
end
