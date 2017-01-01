require 'test_helper'

class NoticeTest < ActiveSupport::TestCase


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
