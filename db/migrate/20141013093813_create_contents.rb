class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :title
      t.string :body
      t.string :category
      t.integer :view, default: 0
      t.integer :download_count, default: 0
      t.string :link
      t.string :file
      t.string :recommend
      t.boolean :main, default: false
      t.boolean :is_open, default: false
      t.boolean :is_remix, default: false
      t.integer :parent_content_id
      t.integer :user_id
      t.timestamps
    end
  end
end
