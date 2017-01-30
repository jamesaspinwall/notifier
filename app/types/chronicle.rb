class Chronicle < ActiveRecord::Type::String
  def serialize(value)
    puts "serialize #{value}"
    value = Chronic.parse(value).to_i if value.is_a? String
    value = Time.current.to_i if value.blank?
    value
  end

  def deserialize(value)
    puts "DE serialize #{value}"
    if value.blank?
      Time.current
    else
      Time.at(value)
    end
  end

  # def cast(value)
  #   binding.pry
  #   if value.present?
  #     if value.is_a? String
  #       Chronic.time_class = Time.zone
  #       # if value =~ /\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}.\d{6}/
  #       #   value += ' UTC'
  #       # end
  #       ret = Chronic.parse(value)
  #       raise ChronicError.new("Error TimeDate parse: can't recognize #{value}") if ret.nil?
  #       ret.to_i
  #     else
  #       value
  #     end
  #   else
  #     nil
  #   end
  # end
end