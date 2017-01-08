Time.zone='America/New_York'
namespace :test_task do
  desc "TODO"
  task check1: :environment do
    Notice.destroy_all
    Notice.create notice_attr(notify_chronic: 'in 1 secs')
    Task.schedule_next_notice

    sleep 2
    Notice.all.each do |notice|
      pp "notice.sent_at: #{notice.sent_at}"
      raise "Error: notice.sent_at: #{notice.zone.sent_at.inspect}" if notice.sent_at.nil?
    end
  end

  task check2: :environment do
    Notice.destroy_all
    Notice.create notice_attr(notify_chronic: 'in 1 secs')
    Notice.create notice_attr(notify_chronic: 'in 2 secs')
    Task.schedule_next_notice

    sleep 3
    Notice.all.each do |notice|
      pp "notice.sent_at: #{notice.sent_at}"
      raise "Error: notice.sent_at: #{notice.zone.sent_at.inspect}" if notice.sent_at.nil?
    end
  end

  task check3: :environment do
    Notice.destroy_all
    1.upto(10) do |n|
      Notice.create notice_attr(notify_chronic: "in #{n} secs")
    end
    Task.schedule_next_notice

    sleep 11
    Notice.all.each do |notice|
      raise "Error: notice.sent_at: #{notice.zone.sent_at.inspect}" if notice.sent_at.nil?
    end
  end

  task check4: :environment do
    Notice.destroy_all
    2.upto(11) do |n|
      Notice.create notice_attr(notify_chronic: "in #{n / 2} secs")
    end
    Task.schedule_next_notice

    sleep 6
    Notice.all.each do |notice|
      raise "Error: notice.sent_at: #{notice.zone.sent_at.inspect}" if notice.sent_at.nil?
    end
  end

  task check5: :environment do
    Notice.destroy_all
    10.downto(1) do |n|
      Notice.create notice_attr(notify_chronic: "in #{n} secs")
    end
    Task.schedule_next_notice

    sleep 11
    Notice.all.order(:id).each do |notice|
      puts notice.sent_at
      raise "Error: notice.sent_at: #{notice.zone.sent_at.inspect}" if notice.sent_at.nil?
    end
  end

  task mail: :environment do
    puts NotifierMailer.notice(subject: 'this is new', content: "Hello there").deliver!
  end

  task mail1: :environment do
    inst = NotifierMailer.notice(subject: 'this is new', content: "Hello there")
    puts inst.send('deliver!')
  end

  task mail_task: :environment do
    Notice.destroy_all
    Notice.create mailer_notice_attr(notify_chronic: 'in 1 secs')
    Task.schedule_next_notice

    sleep 10
    Notice.all.each do |notice|
      pp "notice.sent_at: #{notice.sent_at}"
      raise "Error: notice.sent_at: #{notice.sent_at.inspect}" if notice.sent_at.nil?
    end
  end

  task mail_task2: :environment do
    #require 'timers'

    timers = Timers::Group.new

    Time::DATE_FORMATS[:default] = '%H:%M:%S %Z'

    puts "Start at: #{Time.current}"
    Notice.destroy_all

    Task.schedule_notice(mailer_notice_attr(notify_chronic: 'in 4 secs'))
    Task.schedule_notice(mailer_notice_attr(notify_chronic: 'in 2 secs'))
    Task.schedule_notice(mailer_notice_attr(notify_chronic: 'in 3 secs'))
    Task.schedule_notice(mailer_notice_attr(notify_chronic: 'in 5 secs'))
    Task.schedule_notice(mailer_notice_attr(notify_chronic: 'in 1 secs'))

    sleep 15
    Notice.all.each do |notice|
      pp "notice.sent_at: #{notice.sent_at}"
      raise "Error: notice.sent_at: #{notice.sent_at.inspect}" if notice.sent_at.nil?
    end
    puts "End at: #{Time.current}"
  end

  task send_reminder: :environment do
    count = EmailReminder.count
    EmailReminder.create_notice(email_reminder_attrs)
    raise "Error EmailReminder count hasn't been incremented" unless EmailReminder.count == count + 1
    sleep 7
  end

  task donot_send_reminder: :environment do
    count = EmailReminder.count
    e = EmailReminder.create_notice(email_reminder_attrs(title:'ab'))
    sleep 7
    puts "Error #{e.errors.messages}"
    raise "Error EmailReminder count hasn't been incremented" unless EmailReminder.count == count
  end

  task send_reminder_in_10: :environment do
    EmailReminder.create_notice(email_reminder_attrs({chronic: 'in 10 secs'}))
  end

  def email_reminder_attrs(attrs = {})
    {
      chronic: 'in 1 sec',
      title: 'I am title',
      description: 'I am a little lamb'
    }.merge attrs
  end


  def notice_attr(attr = {})
    {
      title: 'title',
      description: 'description',
      notify_chronic: 'tomorrow',
      inst: Marshal.dump(IAm.new),
      meth: 'yes',
      args: Marshal.dump([123, { x: 1, y: 'xxx', is: Time.current }])
    }.merge attr
  end

  def mailer_notice_attr(attr = {})
    {
      title: 'title',
      description: 'description',
      notify_chronic: 'tomorrow',
      inst: Marshal.dump(NotifierMailer.notice(subject: 'NotifierMailer', content: "#{Time.current}")),
      meth: 'deliver!',
      args: Marshal.dump([])
    }.merge attr
  end

  def show_notices
    puts "Sent at: #{Time.current}"
    Notice.all.order(:id).each do |notice|
      attr = notice.attributes
      attr.delete('inst')
      attr.delete('meth')
      attr.delete('args')
      attr.delete('created_at')
      attr.delete('updated_at')
      attr.delete('title')
      attr.delete('description')
      attr.delete('repeat')
      attr.delete('id')
      attr.delete('cancelled')
      puts attr
    end
    puts '-'*120
  end


end
