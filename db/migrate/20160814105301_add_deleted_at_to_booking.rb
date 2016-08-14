class AddDeletedAtToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :deleted_at, :datetime, default: nil
  end
end
