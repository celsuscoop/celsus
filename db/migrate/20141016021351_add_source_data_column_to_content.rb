class AddSourceDataColumnToContent < ActiveRecord::Migration
  def change
    add_column :contents, :source_info, :text
    add_column :contents, :iframe_html, :text
    add_column :contents, :copyright, :string
  end
end
