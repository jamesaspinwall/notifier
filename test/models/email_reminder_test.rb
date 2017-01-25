require 'test_helper'

class EmailReminderTest < ActiveSupport::TestCase
  test "the truth" do
    skip
    count = EmailReminder.count
    EmailReminder.create_notice(email_reminder_attrs)
    sleep 3
    raise "Error EmailReminder count hasn't been incremented" unless EmailReminder.count == count + 1
  end
end
