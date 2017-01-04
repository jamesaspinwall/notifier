class Marsh < ActiveRecord::Type::Binary

 def cast(value)
   Marshal.dump(value)
 end

  def deserialize(value)
    Marshal.load(value)
  end

  def serialize(value)
    Marshal.dump(value)
  end
end