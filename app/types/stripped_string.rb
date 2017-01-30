class StrippedString < ActiveRecord::Type::String
  def cast_value(value)
    value.to_s.strip
  end
end