class CreateSearchResults < ActiveRecord::Migration[7.1]
  def change
    create_table :search_results do |t|
      t.references :keyword, null: false, foreign_key: true
      t.integer :adwords_count, null: false, default: 0
      t.integer :links_count, null: false, default: 0
      t.string :total_results, null: false
      t.text :html_code, null: false

      t.timestamps
    end
  end
end
