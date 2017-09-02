class AddInvoiceDatesToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :due_date, :datetime, :default => nil
    add_column :bookings, :delivery_date, :datetime, :default => nil
  end
end
