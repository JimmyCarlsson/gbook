class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :type
      t.string :name
      t.string :contact_person
      t.string :email
      t.string :phone_nr
      t.integer :tickets
      t.integer :event_id
      t.timestamps null: false
    end
  end
end
