class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.references :audience, null: false, foreign_key: true, index: false
      t.references :event, null: false, foreign_key: true
      t.references :band, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :tickets, %i(audience_id event_id band_id), unique: true
  end
end
