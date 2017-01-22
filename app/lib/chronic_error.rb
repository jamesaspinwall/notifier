class ChronicError < StandardError
  def initialize(str)
    @str = str
  end
end