class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :name, null: false
      t.string :language

      t.timestamps null: false
    end
  end
end
