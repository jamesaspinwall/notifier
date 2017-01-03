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
    current.timer.cancel if current.timer
    after_block = Proc.new do
      block.call
      Notice.scheduled.sent 
      schedule_next_notice
    end
    current.timer = current.after(time_to_run - Time.current, &after_block)
   end

  def self.schedule_next_notice
    next_notice = Notice.earliest
    if next_notice.present?
      next_notice.update(scheduled_at: Time.current)

      schedule(next_notice.notify_at){
        puts "\n\nABC #{next_notice.attributes}\n" +'-'*80
      }
    end
  end


  def cancel
    @timer.cancel
  end
end