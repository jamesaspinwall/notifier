class NotifierMailer < ApplicationMailer
  def notice(attr = {})
    @content = attr[:content]
    mail({to: 'jamesaspinwall@gmail.com',subject:'email test'}.merge(attr))
  end
end
