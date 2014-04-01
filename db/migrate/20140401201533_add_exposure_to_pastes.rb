class AddExposureToPastes < ActiveRecord::Migration
  def change
    add_column :pastes, :exposure, :integer
  end
end
