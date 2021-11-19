class AddReservationToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :reservation, :boolean, dafault: false, null: false
  end
end
