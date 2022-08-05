class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :band, foreign_key: true, index: false
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end

    add_index :likes, %i[band_id post_id], unique: true
  end
end
