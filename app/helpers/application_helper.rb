# Copyright 2009-2010 Justin Perkins
module ApplicationHelper
  def render_flash
    content_tag(:div, flash[:notice], :id => 'notice') if flash[:notice]
  end
  
  def format_datetime(datetime, options = {})
    options.reverse_merge!(:empty => 'never')
    datetime ? datetime.strftime('%m/%d/%Y %H:%M %Z') : options[:empty]
  end
  
  def display_attribute(record, *args)
    options = (args.last.is_a?(Hash) ? args.pop : {}).reverse_merge(:label => nil, :value => nil)
    attribute = args.pop
    content_tag(:p) do
      label = content_tag(:strong, "#{ options[:label] || attribute.to_s.titleize }:")
      value = options[:value] || record.send(attribute)
      "#{label} #{h(value)}"
    end
  end
end
