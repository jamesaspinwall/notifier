class Notice < ApplicationRecord
  before_validation :set_notify_at
  validates :notify_at, presence: true
  validates :notify_at, must_be_in_the_future: true

  def set_notify_at
    Chronic.time_class = Time.zone
    self.notify_at = Chronic.parse(self.notify_chronic, context: :future)
    #throw :abort
  end
end
