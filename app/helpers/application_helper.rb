# Copyright 2009-2010 Justin Perkins
module ApplicationHelper
  def prebody
    return unless @controller.controller_name == 'intro'
    content_tag(:ul, :class => 'intro-nav') do
      [{:index => 'overview'}, {:guide => 'setup'}, {:what_happens => 'what happens'}].collect { |nav|
        action = nav.keys.first
        content_tag(:li, link_to(nav[action], :action => action))
      }.join("\n")
    end
  end
  
  def render_flash
    content_tag(:div, flash[:notice], :id => 'notice') if flash[:notice]
  end
  
  def format_datetime(datetime, options = {})
    options.reverse_merge!(:empty => 'never')
    datetime ? datetime.strftime('%m/%d/%Y %H:%M %Z') : options[:empty]
  end
  
  def display_attribute(record, *args)
    options = (args.last.is_a?(Hash) ? args.pop : {}).reverse_merge(:label => nil, :value => nil, :extra => nil)
    attribute = args.pop
    content_tag(:p) do
      label = content_tag(:strong, "#{ options[:label] || attribute.to_s.titleize }:")
      value = options[:value] || record.send(attribute)
      "#{label} #{h(value)} #{options[:extra]}"
    end
  end
  
  def rotating_tagline
    taglines = [
      "You have emails you don't want to read and that's OK",
      "The simple email averter",
      "A really easy way to manage the shitty emails of our lives",
      "Hey you, get outta my inbox",
      "Hey Rocky, watch me pull an email out of your inbox"
    ]
    taglines[rand(taglines.size)]
  end

  def errors_for(field, record, options = {})
    options.reverse_merge!(:default => nil)
    if record.errors[field]
      error_message = record.errors[field].respond_to?(:to_sentence) ? record.errors[field].to_sentence : record.errors[field]
      error_message.gsub!(/^(is)/, '')
      error_message.gsub!(/(\.)$/, '')
      content_tag(:em, error_message)
    elsif options[:default]
      content_tag(:em, options[:default])
    end
  end
end
