class ChangeDatatypeOpenAtOfEvents < ActiveRecord::Migration[6.1]
  def change
    change_column :events, :open_at, :time
  end
end
