require 'test_helper'

class NoticeTest < ActiveSupport::TestCase

  test 'notice1' do
    Time.zone = 'America/Los_Angeles'
    assert_difference 'Notice.count' do
      notice = Notice.create notice_attr(notify_chronic: 'tomorrow 11 AM')
      assert_equal tomorrow_11_AM, notice.notify_at
    end
  end

  test 'validator must be in the future' do
    assert_difference 'Notice.count', 0 do
      ['12:00 AM','yesterday'].each do |notify_at|
        notice = Notice.create notice_attr(notify_chronic: notify_at)
        refute_empty notice.errors.messages[:notify_at]
      end
    end
  end

  private

  def tomorrow_11_AM
    Time.zone.now.midnight + 11.hours + 1.day
  end

end
