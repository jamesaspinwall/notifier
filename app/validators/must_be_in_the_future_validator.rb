class MustBeInTheFutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value > Time.current
      record.errors[attribute] << (options[:message] || "must be in the future")
    end
  end
end