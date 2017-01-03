class InTheFutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present? and record.send(attribute.to_s+'_changed?') and value < Time.current
      puts 'Oh boy, I found and error'
      record.errors[attribute] << (options[:message] || "must be in the future")
    end
  end
end