require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

unless ENV['BEAKER_provision'] == 'no'
  hosts.each do |host|
    # Install Puppet
    if host.is_pe?
      install_pe
    else
      install_puppet
    end
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(source: proj_root, module_name: 'nc_nginx')
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib', '--version',
                      '4.7.0'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppetlabs-vcsrepo', '--version',
                      '1.3.1'),  acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'jfryman-nginx', '--version',
                      '0.2.7'),  acceptable_exit_codes: [0, 1]
    end
  end
end
