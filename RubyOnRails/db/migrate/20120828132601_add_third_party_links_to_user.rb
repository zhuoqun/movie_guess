class AddThirdPartyLinksToUser < ActiveRecord::Migration
  def change
    add_column :users, :douban_link, :string
    add_column :users, :weibo_name, :string
  end
end
