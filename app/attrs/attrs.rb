module Attrs
  def self.todo(attrs = {})
    {
      title: "Todo created at #{Time.current}",
      description: 'Just description',
      show_at: Time.current,
      complete_at: nil,
      #belongs_to: context,
      #has_and_belongs_to_many: tags
    }.merge attrs
  end

  def self.context(attrs = {})
    {
      name: "Context name at #{Time.current}"
    }.merge(attrs)
  end

  def self.tag(attrs = {})
    {
      name: "tag name at #{Time.current}"
    }.merge attrs
  end
end
