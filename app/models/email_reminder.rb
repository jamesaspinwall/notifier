class EmailReminder < ApplicationRecord

  validates :title, presence: true

  belongs_to :notice, optional: true

  before_create :schedule_task

  def schedule_task
    attrs = {
      title: 'EmailReminder',
      description: self.title,
      notify_chronic: self.chronic,
      inst: Marshal.dump(NotifierMailer.notice(subject: self.title, content: self.description)),
      meth: 'deliver!',
      args: Marshal.dump([])
    }
    #binding.pry
    self.notice = Notice.create(attrs)


    #self.notice_id = notice.id
    Task.schedule_next_notice

  end
end
