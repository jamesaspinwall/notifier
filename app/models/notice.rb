class Notice < ApplicationRecord
    before_save :set_notify_at

    def set_notify_at
        self.notify_at = Chronic.parse(self.notify_chronic, context: :future)
    end
end
