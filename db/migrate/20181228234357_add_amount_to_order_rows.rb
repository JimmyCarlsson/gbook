class AddAmountToOrderRows < ActiveRecord::Migration
  def change
    add_column :order_rows, :amount, :integer
  end
end
