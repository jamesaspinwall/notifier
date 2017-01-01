class Notice < ApplicationRecord
    before_validation :set_notify_at

    validates :notify_at, presence: true

    def set_notify_at
        self.notify_at = Chronic.parse(self.notify_chronic, context: :future)
    end
end
