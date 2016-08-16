require 'spreadsheet'
class V1::DocumentsController < ApplicationController
  before_action :authenticate_admin_from_token_param!
  before_action :authenticate_admin!

  def show
    event = Event.find_by_id(params[:id])
    if !event
      return
    end

    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet

    sheet.name = "#{event.name}"
    row = sheet.row(1)
    row.push "Event: "
    row.push event.name + " " + event.date.strftime('%F')
    row = sheet.row(2)
    row.push "Uttag datum:"
    row.push DateTime.now.strftime('%FT%R')
    row = sheet.row(3)
    row.push "Bokningar:"
    row = sheet.row(4)
    row.push "Id", "Biljetter", "Namn", "Bokades", "Epost", "Telefon", "Kontaktperson", "Betalat", "Meddelande", "Notering", "Rabatt", "Rabattmeddelande"
    event.bookings.each_with_index do |booking, index|
      row = sheet.row(5+index)
      row.push booking.id, booking.tickets, booking.name, booking.created_at.strftime('%FT%R'), booking.email, booking.phone_nr, booking.contact_person, booking.paid, booking.message, booking.memo, booking.discount, booking.discount_message
    end

    data = StringIO.new ''
    book.write data

    send_data data.string.force_encoding('binary'), type: 'application/excel', disposition: 'attachment', filename: 'report.xls'

  end
end
