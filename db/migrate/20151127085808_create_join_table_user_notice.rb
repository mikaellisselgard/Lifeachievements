class CreateJoinTableUserNotice < ActiveRecord::Migration
  def change
    create_join_table :users, :notices do |_t|
      # t.index [:user_id, :notice_id]
      # t.index [:notice_id, :user_id]
    end
  end
end
