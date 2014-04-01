class AddExpirationToPastes < ActiveRecord::Migration
  def change
    add_column :pastes, :expiration, :timestamp
  end
end
