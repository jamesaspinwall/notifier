class EmailReminderService
  def mail(n)
    reminder = EmailReminder.find(n)
    NotifierMailer.notice(subject: reminder.title, content: reminder.description).deliver!
  end
end