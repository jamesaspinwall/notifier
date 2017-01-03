class Notice < ApplicationRecord
  before_validation :set_notify_at
  validates :notify_at, presence: true
  validates :notify_at, in_the_future: true
  validates :sent_at, date_time: true

  def set_notify_at
    if self.notify_chronic_changed?
      Chronic.time_class = Time.zone
      self.notify_at = Chronic.parse(self.notify_chronic, context: :future)
    end
  end

  def self.earliest
    where(scheduled_at:nil, sent_at: nil).order(:notify_at).first
  end

  def self.scheduled
    where.not(scheduled_at: nil).where(sent_at: nil).first
  end

  def sent
    update!(sent_at: Time.current, scheduled_at:nil)
  end
end
