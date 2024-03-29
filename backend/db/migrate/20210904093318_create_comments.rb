class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :band, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.references :parent, foreign_key: { to_table: :comments }
      t.text :content, null: false

      t.timestamps
    end
  end
end
