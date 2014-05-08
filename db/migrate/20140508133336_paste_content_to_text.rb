class PasteContentToText < ActiveRecord::Migration
  def change
      change_column :pastes, :content, :text
  end
end
