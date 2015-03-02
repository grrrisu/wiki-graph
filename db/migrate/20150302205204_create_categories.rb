class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :language

      t.timestamps null: false
    end

    create_table :categories_terms do |t|
      t.integer :category_id, index: true
      t.integer :term_id, index: true
    end
  end
end
