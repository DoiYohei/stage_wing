class DeviseTokenAuthCreateAudiences < ActiveRecord::Migration[6.1]
  def change
    create_table(:audiences) do |t|
      ## Required
      t.string :provider, null: false, default: 'email'
      t.string :uid, null: false, default: ''

      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean  :allow_password_change, default: false

      ## Rememberable
      t.datetime :remember_created_at

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## User Info
      t.string :name, null: false, dafault: ''
      t.string :email, null: false, dafault: ''
      t.string :image

      ## Tokens
      t.text :tokens

      t.timestamps
    end

    change_table :audiences, bulk: true do |t|
      t.index :email, unique: true
      t.index %i[uid provider], unique: true
      t.index :reset_password_token, unique: true
      t.index :confirmation_token, unique: true
      # add_index :audiences, :unlock_token, unique: true
    end
  end
end
