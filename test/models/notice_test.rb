require 'test_helper'

class NoticeTest < ActiveSupport::TestCase


  test 'notice1' do
    Time.zone = 'America/Los_Angeles'
    Chronic.time_class = Time.zone
    assert_difference 'Notice.count' do
      notice = Notice.create notice_attr()
    end

    t = Time.zone.now.midnight + 11.hours + 1.day
    assert_equal t, notice.notify_at
  end

  private

  def notice_attr(attr = {})
    {
      title: 'title',
      description: 'description',
      notify_chronic: 'tomorrow 11 AM',
    }.merge attr

  end

end
