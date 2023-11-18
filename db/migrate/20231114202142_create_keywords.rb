class CreateKeywords < ActiveRecord::Migration[7.1]
  def change
    create_table :keywords do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, index: true

      t.timestamps
    end
  end
end
