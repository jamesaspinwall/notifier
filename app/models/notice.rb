class Notice < ApplicationRecord

  #attribute :inst, :marsh
  #attribute :args, :marsh

  before_validation :set_notify_at
  validates :notify_at, presence: true
  validates :notify_at, in_the_future: true
  validates :sent_at, date_time: true
  validates :title, length: { minimum: 3 }

  def set_notify_at
    if self.notify_chronic_changed?
      Chronic.time_class = Time.zone
      self.notify_at = Chronic.parse(self.notify_chronic, category: :future)
    end
  end

  def self.earliest
    where(scheduled_at: nil, sent_at: nil).order(:notify_at).first
  end

  def self.scheduled
    where.not(scheduled_at: nil).where(sent_at: nil).first
  end

  def sent
    update!(sent_at: Time.current, scheduled_at: nil)
  end

  def self.cancel_scheduled
    n = self.scheduled
    n.update!(scheduled_at: nil) if n.present?
  end
end

=begin
Notice
  title: string
  description: string
  notify_chronic: string
  repeat: boolean
  notify_at: datetime
  scheduled_at: datetime
  sent_at: datetime
  cancelled: datetime
  inst: binary
  meth: string
  args: binary
  created_at: datetime
  updated_at: datetime
=end