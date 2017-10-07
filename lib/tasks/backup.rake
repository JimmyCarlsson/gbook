namespace :backup do
  desc "Sends a backup email to configured email address containing all booking information for the past 6 months and future events"
  task send_backup_email: :environment do
    book = Spreadsheet::Workbook.new

    # Export all events from the last 6 months (and future events)
    events = Event.where("date >= ?", Date.today - 6.months).order(:date)

    events.each do |event|
      book = event.add_as_sheet(book: book)
    end

    data = StringIO.new ''
    book.write data

    BackupMailer.backup_email(data).deliver_now
  end

end
