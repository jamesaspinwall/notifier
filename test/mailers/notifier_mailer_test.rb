require 'test_helper'

class NotifierMailerTest < ActionMailer::TestCase
  test "send test mail" do
    puts NotifierMailer.notice(subject:'oh oh',content:'ok').deliver!
  end
end
