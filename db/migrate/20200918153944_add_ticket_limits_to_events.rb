class AddTicketLimitsToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :ticket_limit_lower, :integer
    add_column :events, :ticket_limit_higher, :integer
    add_column :events, :ticket_limit_lower_msg, :text
    add_column :events, :ticket_limit_higher_msg, :text
  end
end
