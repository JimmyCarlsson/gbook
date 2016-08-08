class AddBookingToken < ActiveRecord::Migration
  def change
    add_column :bookings, :token, :string, nullable: false
  end
end
