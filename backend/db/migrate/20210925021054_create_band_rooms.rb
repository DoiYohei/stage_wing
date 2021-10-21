class CreateBandRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :band_rooms do |t|
      t.references :band, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true, index: false

      t.timestamps
    end

    add_index :band_rooms, %i(room_id band_id), unique: true
  end
end
