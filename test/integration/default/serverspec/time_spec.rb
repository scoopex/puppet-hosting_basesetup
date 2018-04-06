#----------------------------------------------------------------------
# instantiating testing requirements
#----------------------------------------------------------------------

if (!ENV['w_ssh'].nil? && ENV['w_ssh'] = 'true')
  begin
    require 'spec_helper.rb'
  rescue LoadError
  end
else
  begin
    require 'spec_helper.rb'
    set :backend, :exec
  rescue LoadError
  end
end
#----------------------------------------------------------------------

#  http://serverspec.org/resource_types.html

#----------------------------------------------------------------------
# testing ntp basic service
#----------------------------------------------------------------------
describe package('ntp') do
  it { should be_installed }
end

describe service('ntp') do
  it { should be_enabled }
end

describe service('ntp') do
  it { should be_running }
end

#----------------------------------------------------------------------
# testing rng-tools basic service
#----------------------------------------------------------------------
describe package('rng-tools') do
  it { should be_installed }
end

describe service('rng-tools') do
  it { should be_enabled }
end

describe service('rng-tools') do
  it { should be_running }
end

#----------------------------------------------------------------------
# testing basic function
#----------------------------------------------------------------------

describe command('ntpq -c peers') do
  its(:stdout) { should match(/^\*/) }
end

describe command('rngtest -c 100 </dev/urandom') do
  its(:exit_status) { should eq 0 }
end

describe command('cat /etc/ntp.conf') do
  its(:stdout) { should match(/10.10.10./) }
end
#----------------------------------------------------------------------

