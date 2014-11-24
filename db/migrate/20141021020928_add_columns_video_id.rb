class AddColumnsVideoId < ActiveRecord::Migration
  def change
    add_column :contents, :remote_content_id, :string
  end
end
