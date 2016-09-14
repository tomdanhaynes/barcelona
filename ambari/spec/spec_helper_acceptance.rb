require 'beaker-rspec'
require 'net/ssh/gateway'


unless (ENV['RS_PROVISION'] == 'no' or ENV['BEAKER_provision'] == 'no')

  hosts.each do |host|


    # Install Puppet
    version = ENV['PUPPET_VERSION'] || '3.3.2'
    if host.is_pe?
      install_pe
    else
      install_puppet_on(host, :version => version)
    end


    common_yaml =<<EOF
classes:
 - ambari::server

ambari::server::ownhostname: puppet-agent.np-ii-test1
EOF

    # provision the master and agent
    if host['roles'].include?('master')

      #add PuppetMaster configuration
      on host, "/bin/mkdir -p /etc/puppet/manifests"
      on host,  "echo $'node default {\n  hiera_include(\'classes\')\n}' > /etc/puppet/manifests/site.pp"
      on host, "/bin/mkdir -p /etc/puppet/hieradata"
      create_remote_file host, "/etc/puppet/hieradata/common.yaml", common_yaml
      on host, "/bin/chmod 755 /etc/puppet/hieradata/common.yaml"
      on host, "/bin/echo $':backends:\n  - yaml\n:yaml:\n  :datadir: /etc/puppet/hieradata\n:hierarchy:\n  - common\n' > /etc/puppet/hiera.yaml"

    # install puppet master
      on host, "yum install -y puppet-server-#{version}"
      on host, "echo '*' > /etc/puppet/autosign.conf"

      #configure puppet
      config = {
        'main' => {
          'server'   => 'puppet-master.np-ii-test1',
          'certname' => 'puppet-master.np-ii-test1',
          'logdir'   => '/var/log/puppet',
          'vardir'   => '/var/lib/puppet',
          'ssldir'   => '/var/lib/puppet/ssl',
          'rundir'   => '/var/run/puppet'
          },
          'agent' => {
            'environment' => 'vagrant'
          }
        }
        #configure puppet master and install common modules
        configure_puppet_on(master, config)
        on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
        on host, puppet('module','install','puppetlabs-java'), { :acceptable_exit_codes => [0,1] }

        master_name = "puppet-master.np-ii-test1"
        on host, "echo '10.255.33.135   #{master_name}' >> /etc/hosts"
        on host, "hostname #{master_name}"

        on host, "/etc/init.d/puppetmaster restart"
      else


        master = only_host_with_role(hosts, 'master')
        master_fqdn = "puppet-master.np-ii-test1"
        agent_fqdn = "puppet-agent.np-ii-test1"

        config = {
          'main' => {
            'server'   => master_fqdn,
            'certname' => agent_fqdn,
            'logdir'   => '/var/log/puppet',
            'vardir'   => '/var/lib/puppet',
            'ssldir'   => '/var/lib/puppet/ssl',
            'rundir'   => '/var/run/puppet'
            },
            'agent' => {
              'environment' => 'vagrant'
            }
          }
          configure_puppet_on(agents, config)

        end
      end
    end


      RSpec.configure do |c|

        # readable test descriptions
        c.default_formatter = :documentation

        # Ambari_server Project root
        proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

        c.before :suite do

        puts "Installing ambari module on master";
        copy_module_to(master, :source => proj_root, :module_name => 'ambari', :protocol => 'scp', :target_module_path => '/etc/puppet/modules')
      end
    end
