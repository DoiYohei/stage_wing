class AddAudienceToLikes < ActiveRecord::Migration[6.1]
  def change
    add_reference :likes, :audience, null: true, foreign_key: true, index: false
    add_index :likes, %i(audience_id post_id), unique: true
  end
end
