class ChangeDatatypeStartAtOfEvents < ActiveRecord::Migration[6.1]
  def change
    change_column :events, :start_at, :time
  end
end
