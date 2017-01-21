class ChronicError < Error
  def initialize(str)
    @str = str
  end
end