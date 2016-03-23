require 'rspec'
require 'chefspec'
require 'chefspec/librarian'

RSpec.configure do |config|
  config.platform = 'mac_os_x'
  config.version = '10.10'

  config.log_level = :debug

  config.before { stub_const('ENV', 'SUDO_USER' => 'fauxhai') }
end
