class AddSearchStatusToKeywords < ActiveRecord::Migration[7.1]
  def up
    add_column :keywords, :search_status, :integer, default: 0, null: false
  end

  def down
    remove_column :keywords, :search_status
  end
end
