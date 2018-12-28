class AddHiddenFieldToEvent < ActiveRecord::Migration
  def change
    add_column :events, :hidden, :boolean, default: false
  end
end
