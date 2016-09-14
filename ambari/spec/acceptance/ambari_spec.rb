require 'spec_helper_acceptance'

pp = <<-EOS
    class { 'ambari::server': }
EOS

describe 'ambari::server class:' do
  it 'should run successfully' do
      agent = only_host_with_role(hosts, 'agent')

      #First run should either exit 2 or 0, depending on whether the puppet run applies changes
      on agent, puppet_agent('--no-daemonize --verbose --onetime --test'), { :acceptable_exit_codes => [0,2] }

  end

  it 'should be idempotent when applied' do
      agent = only_host_with_role(hosts, 'agent')
      run_agent_on(agent)
      expect(run_agent_on(agent).exit_code).to be_zero
  end

  describe file('/etc/security/limits.conf') do
    it { should contain '* soft nofile 10000' }
  end
  describe file('/etc/security/limits.conf') do
    it { should contain '* hard nofile 10000' }
  end

  describe file('/sys/kernel/mm/transparent_hugepage/enabled') do
    it { should contain 'always madvise [never]'}
  end
  describe file('/sys/kernel/mm/transparent_hugepage/defrag') do
    it { should contain 'always madvise [never]'}
  end

  describe file('/etc/ambari-server/conf/ambari.properties') do
    it { should contain 'java.home=/opt/java'}
  end

  describe file('/etc/ambari-server/conf/log4j.properties') do
      it { should exist }
  end


   describe user('hdpadmin') do
     it { should exist }
   end

   describe group('hadoop') do
     it { should exist }
   end



   describe package('ambari-server') do
     it { should be_installed }
   end





end
