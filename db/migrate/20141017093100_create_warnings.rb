class CreateWarnings < ActiveRecord::Migration
  def change
    create_table :warnings do |t|
      t.integer :content_id
      t.integer :user_id
      t.text :cause
      t.timestamps
    end
  end
end
