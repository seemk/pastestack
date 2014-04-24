class AddRandomizedTitleToPastes < ActiveRecord::Migration
  def change
      add_column :pastes, :has_randomized_title, :boolean
  end
end
