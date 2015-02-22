class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :term_id, index: true
      t.integer :linked_term_id, index: true
      t.integer :link_on_term_counter
      t.integer :term_on_link_counter
      t.integer :weight

      t.timestamps null: false
    end
  end
end
