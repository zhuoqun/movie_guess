class AddNameFilterToUser < ActiveRecord::Migration
  def change
    add_column :users, :name_filter, :string
    add_index  :users, :name_filter
  end
end
