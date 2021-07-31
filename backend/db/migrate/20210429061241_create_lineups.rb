class CreateLineups < ActiveRecord::Migration[6.1]
  def change
    create_table :lineups do |t|
      t.references :event, null: false, foreign_key: true, index:false
      t.references :performer, null: false

      t.timestamps
    end

    add_index :lineups, %i(event_id performer_id), unique: true
  end
end
