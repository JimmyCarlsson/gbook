class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|

      t.datetime :date
      t.string :name
      t.string :description
      t.integer :price
      t.integer :seats

      t.timestamps null: false
    end
  end
end
