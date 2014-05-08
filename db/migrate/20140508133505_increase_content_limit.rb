class IncreaseContentLimit < ActiveRecord::Migration
  def change
      change_column :pastes, :content, :string, :limit => 50000
  end
end
