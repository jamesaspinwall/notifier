require 'test_helper'

class NoticeTest < ActiveSupport::TestCase

  test 'notice1' do
    Time.zone = 'America/Los_Angeles'
    assert_difference 'Notice.count' do
      notice = Notice.create notice_attr(notify_chronic: 'tomorrow 11 AM')
      assert_equal tomorrow_11_AM, notice.notify_at
    end
  end

  private


  def tomorrow_11_AM
    Time.zone.now.midnight + 11.hours + 1.day
  end

end
