class CreateFriendships < ActiveRecord::Migration[6.1]
  def change
    create_table :friendships do |t|
      t.bigint :follower_id, null: false
      t.bigint :followed_id, null: false

      t.timestamps
    end
    
    add_index :friendships, :follower_id
    add_index :friendships, :followed_id
    add_index :friendships, %i(follower_id followed_id), unique: true
  end
end