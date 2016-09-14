require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'mocha'
require 'fileutils'


fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))
# include common helpers
#support_path = File.expand_path(File.join(__FILE__, '..', 'support/*.rb'))

#Copy module into fixtures path
FileUtils.mkdir_p File.expand_path(File.join(fixture_path, 'modules/ambari'))
FileUtils.cp_r(File.expand_path(File.join(__FILE__,'../../manifests')),File.expand_path(File.join(fixture_path, 'modules/ambari')), :remove_destination => true)

#Dir[support_path].each { |f| require f }
RSpec.configure do |c|
	c.hiera_config = 'spec/fixtures/hiera/hiera.yaml'
    c.default_formatter = :documentation
    c.manifest_dir = File.join(fixture_path, 'manifests')
    c.module_path = File.join(fixture_path, 'modules')
    c.mock_with :mocha
end
