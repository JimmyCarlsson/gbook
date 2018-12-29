class CreateOrderRows < ActiveRecord::Migration
  def change
    create_table :order_rows do |t|

      t.integer :booking_id
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
