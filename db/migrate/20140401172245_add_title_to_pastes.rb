class AddTitleToPastes < ActiveRecord::Migration
  def change
    add_column :pastes, :title, :string
  end
end
