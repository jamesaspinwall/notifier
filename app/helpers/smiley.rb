class ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::AssetTagHelper

  # Accepts an int and displays a smiley based on >, <, or = 0
  def smile_tag(method, options = {})
    value = @object.nil? ? 0 : @object.send(method).to_i
    options[:id] = field_id(method,options[:index])
    smiley = ":-|"
    if value > 0
      smiley = ":-)"
    elsif smiley < 0
      smiley = ":-("
    end
    return text_field_tag(field_name(method,options[:index]),options) + smiley
  end

  def field_name(label,index=nil)
    output = index ? "[#{index}]" : ''
    return @object_name + output + "[#{label}]"
  end

  def field_id(label,index=nil)
    output = index ? "_#{index}" : ''
    return @object_name + output + "_#{label}"
  end

end