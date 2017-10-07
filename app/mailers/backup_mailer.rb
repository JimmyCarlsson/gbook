class BackupMailer < ApplicationMailer
 
  def backup_email(file)
    
    attachments["bookings_copied_#{Date.today.strftime('%F')}.xls"] = file.string.force_encoding('binary')
    subject_prefix = Rails.env.production? ? "" : "TEST - "
    mail(
      from: "Grebbans <noreply@grebbans.se>",
      to: "bookings@grebbans.se",
      subject: subject_prefix + "Backup av bokningar #{Date.today.strftime('%F')}")
  end
end
