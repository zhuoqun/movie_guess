class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :avatar
      # 0:female, 1:male, -1:unknown
      t.integer :gender, :default => -1
      t.string :password
      t.string :password_salt
      t.string :email
      t.string :domain
      t.string :brief
      t.integer :location_id
      t.boolean :from_provider, :default => false
      t.boolean :disable, :default => false
      t.string :password_reset_token
      t.datetime :password_reset_sent_at
      t.string :extra1
      t.string :extra2
      t.string :extra3
      t.string :extra4
      t.string :extra5

      t.timestamps
    end
  end
end
