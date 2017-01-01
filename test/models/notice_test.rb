require 'test_helper'

class NoticeTest < ActiveSupport::TestCase

    test 'Schedule one' do
        a=8
        proc = Proc.new {
            a=44
        }
        Task.current.schedule(0.3, proc)
        sleep 0.4
        assert_equal 44, a
    end

    test 'Schedule two' do
        a=8
        proc = Proc.new {
            a=44
        }
        Task.current.schedule(0.3, proc)
        Task.current.timer.cancel
        sleep 0.4
        assert_equal 8, a
    end

    test 'schedule three' do
        a=8
        proc1 = Proc.new { a=44 }
        proc2 = Proc.new { a=66 }
        Task.current.schedule(0.3, proc1)
        Task.current.timer.cancel
        Task.current.schedule(0.2, proc2)
        sleep 0.4
        assert_equal 66, a
    end

    test 'notice1' do
        Time.zone = 'America/Los_Angeles'
        Chronic.time_class = Time.zone
        #notify_at = Chronic.parse('tomorrow 10 am', context: :future)
        notice = Notice.create notice_attr()
        t = Time.zone.now.midnight + 11.hours + 1.day
        assert_equal t, notice.notify_at
    end

    private

    def notice_attr( attr = {})
        {
           title: 'title',
           description: 'description',
           notify_chronic: 'tomorrow 11 AM',
        }.merge attr

    end

end
