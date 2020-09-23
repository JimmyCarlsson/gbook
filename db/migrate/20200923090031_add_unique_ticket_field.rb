class AddUniqueTicketField < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :unique_ticket, :boolean
  end
end
