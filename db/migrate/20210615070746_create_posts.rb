class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :format, null: false
      t.string :photo
      t.string :audio
      t.string :media_pass
      t.text :description
      t.references :band, foreign_key: true

      t.timestamps
    end

    add_index :posts, %i(band_id created_at)
  end
end
