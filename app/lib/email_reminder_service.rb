class EmailReminderService
  def self.mail(n)
    reminder = EmailReminder.find(n)
    NotifierMailer.notice(subject: reminder.title, content: reminder.description).deliver!
  end

  def self.pushover(message='test')
    app_config = YAML.load_file('config/config.yml')

    url = URI.parse("https://api.pushover.net/1/messages.json")
    req = Net::HTTP::Post.new(url.path)
    data = {
      token: app_config['token'],
      user: app_config['user'],
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

