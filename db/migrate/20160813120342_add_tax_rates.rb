class AddTaxRates < ActiveRecord::Migration
  def change
    add_column :events, :tax6, :integer, default: 0
    add_column :events, :tax12, :integer, default: 0
    add_column :events, :tax25, :integer, default: 0
  end
end
