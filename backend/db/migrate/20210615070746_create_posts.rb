class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :format, null: false
      t.string :photo
      t.string :audio
      t.string :media_pass
      t.text :description
      t.references :band, null: false, foreign_key: true
      t.integer :likes_count, default: 0

      t.timestamps
    end
  end
end
