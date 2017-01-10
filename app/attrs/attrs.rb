module Attrs
  def self.todo
    {
      context_id: Context.first.id,
      title: "Todo created at #{Time.current}",
      description: 'Just description',
      tags_id: nil,
      show_at: nil,
      complete_at: nil,
      #belongs_to: context,
      #has_and_belongs_to_many: tags
    }
  end

  def self.context(attrs = {})
    {
      name: "Context name at #{Time.current}"
    }.merge(attrs)
  end
end
