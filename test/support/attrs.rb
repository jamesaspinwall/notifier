module Attrs
  def todo_attrs(attrs = {})
    {
      title: "title field",
      description: 'Just description',
      show_at_chronic: 'now',
      started_at: nil,
      complete_at: nil,
    }.deep_merge attrs
  end

  def category_attrs(attrs = {})
    {
      name: "Category name at #{Time.current}"
    }.deep_merge attrs
  end

  def tag_attrs(attrs = {})
    {
      name: "tag name at #{Time.current.to_f}"
    }.deep_merge attrs
  end

  def email_reminder_attrs(attrs = {})
    {
      chronic: 'in 1 sec',
      title: 'I am title',
      description: 'I am a little lamb'
    }.merge attrs
  end

  def notice_attrs(attr = {})
    {
      title: 'title',
      description: 'description',
      notify_chronic: 'tomorrow',
      inst: Marshal.dump(Hash.new),
      meth: 'yes',
      args: Marshal.dump({ x: 1, y: 'xxx', is: Time.current })
    }.merge attr
  end

  def mailer_notice_attrs(attr = {})
    {
      title: 'title',
      description: 'description',
      notify_chronic: 'tomorrow',
      inst: Marshal.dump(NotifierMailer.notice(subject: 'NotifierMailer', content: "#{Time.current}")),
      meth: 'deliver!',
      args: Marshal.dump([])
    }.merge attr
  end

  def person_attrs(attrs = {})
    {
      name: "John (#{Time.current.to_f})",
      phone: '888-888-1111',
      email: "john_#{Time.current.to_f}@work.com"
    }
  end

  def company_attrs(attrs = {})
    {
      name: "IBM (#{Time.current.to_f})"
    }
  end
end

