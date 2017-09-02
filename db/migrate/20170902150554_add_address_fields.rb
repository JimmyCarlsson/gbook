class AddAddressFields < ActiveRecord::Migration
  def change
    add_column :bookings, :address_street, :string, :default => ""
    add_column :bookings, :address_zip, :string, :default => ""
    add_column :bookings, :address_city, :string, :default => ""
  end
end
