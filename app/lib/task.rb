class Task
  include Celluloid

  def self.current
    if @task.nil?
      @task = new
    else
      @task
    end
  end

  attr_accessor :timer

  def self.schedule(time_to_run, &block)
    raise "not a time" unless time_to_run.is_a?(Time)
     if current.timer
       current.timer.cancel
     end

    after_block = Proc.new do
      block.call
      Notice.scheduled.sent
      schedule_next_notice
    end
    current.timer = current.after(time_to_run - Time.current, &after_block)
  end

  def self.schedule_next_notice
    Notice.cancel_scheduled
    next_notice = Notice.earliest
    if next_notice.present?
      next_notice.update(scheduled_at: Time.current)

      schedule(next_notice.notify_at) {
        notice = Notice.scheduled

        inst = Marshal.load(notice.inst)
        args = Marshal.load(notice.args)

        inst.send(notice.meth, *args)
       }
    end
  end

  def self.schedule_notice(attrs)
    Notice.create(attrs)
    schedule_next_notice
  end

  def cancel
    @timer.cancel
  end

  def self.show_notices
    puts "Sent at: #{Time.current}"
    Notice.all.order(:id).each do |notice|
      attr = notice.attributes
      %w(id inst meth args created_at updated_at title description repeat cancelled).each do |name|
        attr.delete(name)
      end
      puts attr
    end
    puts '-'*120
  end
end