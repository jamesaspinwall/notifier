module Attrs::Person
  def person_attrs(attrs={})
    {
      name: 'James'
    }.deep_merge(attrs)
  end

end

module Minitest
  class Test
    include Attrs::Person
  end
end



