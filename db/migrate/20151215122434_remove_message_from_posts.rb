class RemoveMessageFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :message, :string
  end
end
