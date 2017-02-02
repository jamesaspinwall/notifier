class EmailReminderService
  def self.mail(n)
    reminder = EmailReminder.find(n)
    NotifierMailer.notice(subject: reminder.title, content: reminder.description).deliver!
  end

  def self.pushover(message='test')
    url = URI.parse("https://api.pushover.net/1/messages.json")
    req = Net::HTTP::Post.new(url.path)
    data = {
      token: "au9x1jpb6of8rp81cvxvt5qj4tph6v",
      user: "upxpu88ksz1xxwad35unfj7uokczj4",
      message: message
    }

    req.set_form_data(data)
    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true
    res.verify_mode = OpenSSL::SSL::VERIFY_PEER
    res.start { |http|
      http.request(req)
    }
  end
end

