class RenameType < ActiveRecord::Migration
  def change
    rename_column :bookings, :type, :booking_type
  end
end
