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

  def schedule(n, block=nil, &b)
    if block_given?
      params = yield
      @timer = after(n) {
        puts "#{params}"
        puts 'Here I am'
      }
    elsif block
      @timer = after(n,&block)
    else
      @timer = after(n){
        puts "Time: #{Time.now}"
      }
    end

  end

  def cancel
    @timer.cancel
  end
end