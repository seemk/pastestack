class Addtokentopastes < ActiveRecord::Migration
  def change
      add_column :pastes, :token, :string
  end
end
