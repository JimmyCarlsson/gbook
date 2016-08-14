class AddFieldsToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :discount, :integer, default: nil
    add_column :bookings, :discount_message, :text
    add_column :bookings, :message, :text
    add_column :bookings, :paid, :boolean, default: false
    add_column :bookings, :memo, :text
  end
end
