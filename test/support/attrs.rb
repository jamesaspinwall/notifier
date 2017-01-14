module Attrs
  def todo_attrs(attrs = {})
    {
      title: "Todo created at #{Time.current}",
      description: 'Just description',
      show_at: Time.current,
      complete_at: Time.current + 1.day,
      #belongs_to: category,
      #has_and_belongs_to_many: tags
    }.deep_merge attrs
  end

  def category_attrs(attrs = {})
    {
      name: "Category name at #{Time.current}"
    }.deep_merge(attrs)
  end

  def tag_attrs(attrs = {})
    {
      name: "tag name at #{Time.current}"
    }.deep_merge attrs
  end
end

