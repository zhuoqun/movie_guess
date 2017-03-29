class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :user_id
      t.string :provider
      t.string :uid
      t.string :url
      t.string :oauth_token
      t.string :extra1
      t.string :extra2
      t.string :extra3
      t.string :extra4
      t.string :extra5

      t.timestamps
    end
  end
end
