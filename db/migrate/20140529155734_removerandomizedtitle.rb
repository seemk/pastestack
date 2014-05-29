class Removerandomizedtitle < ActiveRecord::Migration
  def change
      remove_column :pastes, :has_randomized_title
  end
end
