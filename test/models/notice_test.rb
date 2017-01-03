require 'test_helper'

class NoticeTest < ActiveSupport::TestCase
  include MyHelper

  test 'my helper' do
    assert return_true
  end

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

  test 'invalid chonic' do
    notice = Notice.create notice_attr(notify_chronic: 'this is not chronic')
    refute_empty notice.errors.messages[:notify_at]
  end

  test 'soonest valid' do
    assert_nil Notice.earliest
    n5 = Notice.create notice_attr(notify_chronic: 'in 5 secs')
    n2 = Notice.create notice_attr(notify_chronic: 'in 2 secs')
    assert_equal n2, Notice.earliest
    n2.sent
    n3 = Notice.create notice_attr(notify_chronic: 'in 3 secs')
    assert_equal n3, Notice.earliest
    n3.sent
    assert_equal n5, Notice.earliest
    n5.sent
    assert_nil Notice.earliest
  end

  test 'schedule next notice' do
    skip
    Notice.destroy_all
    n5 = Notice.create notice_attr(notify_chronic: 'in 3 secs')
    Task.schedule_next_notice
    sleep 5
    #puts "sent_at: #{n5.sent_at.inspect}"
    #refute_nil n5.sent_at
  end

  test 'update valid sent_at validator' do
    notice = Notice.create notice_attr(notify_chronic: 'in 3 secs')
    notice.update(sent_at: '2005-01-01')
    assert_empty notice.errors.messages[:sent_at]
  end

  test 'update INVALID sent_at validator' do
    notice = Notice.create notice_attr(notify_chronic: 'in 3 secs')
    notice.update(sent_at: 'xxx')
    refute_empty notice.errors.messages[:sent_at]
  end

  test 'update nil sent_at validator' do
    notice = Notice.create notice_attr(notify_chronic: 'in 3 secs')
    notice.update(sent_at: '2005-01-01')
    assert_empty notice.errors.messages[:sent_at]
    notice.update(sent_at: nil)
    assert_empty notice.errors.messages[:sent_at]
  end

  private

  def tomorrow_11_AM
    Time.zone.now.midnight + 11.hours + 1.day
  end

end
