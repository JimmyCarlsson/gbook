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

    book = event.add_as_sheet(book: book)

    data = StringIO.new ''
    book.write data

    send_data data.string.force_encoding('binary'), type: 'application/excel', disposition: 'attachment', filename: "event_#{event.name}_#{event.date.strftime('%F')}_copied_#{Date.today.strftime('%F')}.xls"

  end

  def index

    book = Spreadsheet::Workbook.new

    # Export all events from the last 6 months (and future events)
    events = Event.where("date >= ?", Date.today - 6.months).order(:date)

    events.each do |event|
      book = event.add_as_sheet(book: book)
    end

    data = StringIO.new ''
    book.write data

    send_data data.string.force_encoding('binary'), type: 'application/excel', disposition: 'attachment', filename: "bookings_copied_#{Date.today.strftime('%F')}.xls"

  end
end
