class AddDateToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :date, :date, null: false
  end
end
