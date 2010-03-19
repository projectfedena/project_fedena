require File.join(File.dirname(__FILE__), 'boot')
require "pdf/writer"
require "pdf/simpletable"
Rails::Initializer.run do |config|
  config.gem "declarative_authorization", :source => "http://gemcutter.org"
  config.time_zone = 'UTC'
  config.gem 'prawn', :version=>'0.6.3'

  config.action_controller.session = {
    :session_key => '_fedena_session',
    :secret      => '414909bfa58bf168d2ffde2ddad6afad5d3b7fca8025598337b55efa2e665d263993792f78fe346c15c1ea5f4b08fd7696de24c7968d55b2d198348478944f0b'
  }
  config.load_once_paths += %W( #{RAILS_ROOT}/lib )
end
