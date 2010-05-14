RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'authlogic'
end

# set errors on inputs/selects to be wrapped with a span instead of the default div
ActionView::Base.field_error_proc = Proc.new{ |html_tag, instance|
  "<span class=\"fieldWithErrors\">#{html_tag}</span>" 
}