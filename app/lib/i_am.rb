class IAm

  def initialize
    @created_at = Time.current
  end
  def yes(a,b)
    puts "Yes, I was created at #{@created_at} and Time.current #{Time.current} with a: #{a} and b: #{b}"
    true
  end
end