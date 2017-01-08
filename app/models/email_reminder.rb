class EmailReminder < ApplicationRecord

  validates :title, presence: true
  validates :send_at, presence: true
  validates :send_at, in_the_future: true
  validates_associated :notice

  belongs_to :notice, optional: true

  before_validation :set_send_at
  #after_create :schedule_task

  def self.create_notice(attrs)
    reminder = new(attrs)
    reminder.notice = Notice.new({
      title: reminder.title,
      description: 'created by EmailReminder',
      notify_at: Chronic.parse(reminder.chronic),
      inst: Marshal.dump(EmailReminderService.new),
      meth: 'mail',
      args: nil
    })

    if reminder.valid?
      reminder.save!
      reminder.notice.update(args: Marshal.dump([reminder.id]))
      Task.schedule_next_notice
    end
    reminder
  end

  def set_send_at
    if self.chronic_changed?
      Chronic.time_class = Time.zone
      self.send_at = Chronic.parse(self.chronic, context: :future)
    end
  end
end

=begin
EmailReminder
  chronic: string
  title: string
  description: text
  send_at: datetime
  notice_id: integer

  belongs_to :notice
=end