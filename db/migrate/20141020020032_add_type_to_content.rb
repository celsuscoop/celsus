class AddTypeToContent < ActiveRecord::Migration
  def change
    add_column :contents, :type, :string
    remove_column :contents, :category, :string
  end
end
