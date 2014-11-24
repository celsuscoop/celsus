class AddColumnOwnerToContent < ActiveRecord::Migration
  def change
    add_column :contents, :owner_name, :string
    add_column :contents, :owner_url, :string
  end
end
