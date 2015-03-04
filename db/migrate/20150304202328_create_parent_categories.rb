class CreateParentCategories < ActiveRecord::Migration
  def change
    create_table :parent_categories do |t|
      t.integer :parent_id, index: true
      t.integer :child_id, index: true
      t.timestamps null: false
    end
  end
end
