class AddColumnsToContentExtraCopyright < ActiveRecord::Migration
  def change
    add_column :contents, :extra_copyright, :boolean
  end
end
