class EmailReminder < ApplicationRecord

  validates :title, presence: true
  validates :send_at, presence: true
  validates :send_at, in_the_future: true

  belongs_to :notice, optional: true

  before_validation :set_send_at
  #after_create :schedule_task

  def self.create_with_task(attrs)
    reminder = new(attrs)

    if reminder.save
      notice_attrs = {
        title: 'EmailReminderService',
        description: reminder.title,
        notify_at: reminder.send_at,
        inst: Marshal.dump(EmailReminderService.new),
        meth: 'mail',
        args: Marshal.dump([reminder.id])
      }
      reminder.notice = Notice.create(notice_attrs)
      Task.schedule_next_notice
    end
  end

  def set_send_at
    if self.chronic_changed?
      Chronic.time_class = Time.zone
      self.send_at = Chronic.parse(self.chronic, context: :future)
    end
  end
end
