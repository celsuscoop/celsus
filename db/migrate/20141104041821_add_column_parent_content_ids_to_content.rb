class AddColumnParentContentIdsToContent < ActiveRecord::Migration
  def change
    remove_column :contents, :parent_content_id, :integer
    add_column :contents, :parent_content_ids, :text
  end
end