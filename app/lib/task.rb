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

  def schedule(n, block=nil, title=nil, &b)
    if block_given?
      params = yield
    end
    if block
      @timer = after(n,&block)
    else
      @timer = after(n, title){
        puts "Time: #{Time.now}"
      }
    end

  end

  def cancel
    @timer.cancel
  end
end