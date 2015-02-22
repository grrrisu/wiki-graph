class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :page, null: false
      t.string :name

      t.timestamps null: false
    end
  end
end
