class ChangeDataTypeForLines < ActiveRecord::Migration
  def up
    change_table :puzzles do |t|
      t.change :lines, :text, :limit => nil
    end
  end

  def down
  end
end
