class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :band, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.text :content, null: false

      t.timestamps
    end
  end
end
