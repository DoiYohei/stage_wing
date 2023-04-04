class ChangeColumnToNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :events, :open_at, true
    change_column_null :events, :start_at, true
    change_column_null :events, :place, true
  end
end
