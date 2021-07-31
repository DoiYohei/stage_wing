class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.bigint :owner_id
      t.string :name, null:false
      t.string :flyer
      t.string :place, null:false
      t.datetime :open_at, null:false
      t.datetime :start_at, null:false
      t.integer :ticket_price
      t.text :content
      t.text :unregistered_performers

      t.timestamps
    end

    add_index :events, :owner_id
  end
end
