class CreatePastes < ActiveRecord::Migration
  def change
    create_table :pastes do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :pastes, [:user_id, :created_at]
  end
end
