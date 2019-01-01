class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|

      t.string :name
      t.string :description
      t.integer :price
      t.integer :tax6
      t.integer :tax12
      t.integer :tax25

      t.timestamps null: false
    end
  end
end
