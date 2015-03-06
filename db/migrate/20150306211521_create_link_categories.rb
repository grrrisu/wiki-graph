class CreateLinkCategories < ActiveRecord::Migration
  def change
    create_table :link_categories do |t|
      t.integer :link_id, index: true
      t.integer :category_id, index: true
      t.integer :link_depth
      t.integer :linking_depth
      t.timestamps null: false
    end
  end
end
