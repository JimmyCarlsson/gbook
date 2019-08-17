class AddItemsToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :items, :integer, array: true, default: []
  end
end
