RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION
RAILS_ENV = 'production'

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'authlogic'
  config.gem 'ruby-gmail', :lib => 'gmail', :version => '>= 0.2.1', :source => 'http://gemcutter.org/gems/ruby-gmail'
  config.gem 'mail', :version => '2.2.1'
end

# set errors on inputs/selects to be wrapped with a span instead of the default div
ActionView::Base.field_error_proc = Proc.new{ |html_tag, instance|
  "<span class=\"fieldWithErrors\">#{html_tag}</span>" 
}
