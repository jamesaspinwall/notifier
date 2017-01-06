class EmailReminder < ApplicationRecord

  validates :title, presence: true

  belongs_to :notice, optional: true

  after_create :schedule_task

  def schedule_task
    attrs = {
      title: 'EmailReminderService',
      description: self.title,
      notify_chronic: self.chronic,
      inst: Marshal.dump(EmailReminderService.new),
      meth: 'mail',
      args: Marshal.dump([self.id])
    }
    self.notice = Notice.create(attrs)


    #self.notice_id = notice.id
    Task.schedule_next_notice

  end
end
