class CreateFriendships < ActiveRecord::Migration[6.1]
  def change
    create_table :friendships do |t|
      t.references :follower, null: false, foreign_key: { to_table: :bands }, index: false
      t.references :followed, null: false, foreign_key: { to_table: :bands }

      t.timestamps
    end

    add_index :friendships, %i[follower_id followed_id], unique: true
  end
end
