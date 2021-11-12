class AddAudienceToComments < ActiveRecord::Migration[6.1]
  def change
    add_reference :comments, :audience, null: true, foreign_key: true
  end
end
