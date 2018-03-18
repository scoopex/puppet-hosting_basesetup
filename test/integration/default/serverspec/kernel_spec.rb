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
# testing basic function
#----------------------------------------------------------------------

describe command('sysctl -n kernel.panic_on_oops') do
   its(:stdout) { should match(/30/) }
end

describe command('sysctl -n net.core.netdev_max_backlog') do
   its(:stdout) { should match(/30000/) }
end

describe command('ulimit -n') do
   its(:stdout) { should match(/8192/) }
end

describe command('cat /sys/kernel/mm/transparent_hugepage/defrag') do
   its(:stdout) { should match(/\[never\]/) }
end

describe command('cat /sys/class/block/sda//queue/read_ahead_kb') do
   its(:stdout) { should match(/^8$/) }
end

describe command('cat /etc/default/grub') do
   its(:stdout) { should match(/foobarbaz/) }
end

describe command('/etc/init.d/sysfsutils restart') do
  its(:exit_status) { should eq 0 }
end

describe command('sysctl -p') do
  its(:exit_status) { should eq 0 }
end

#----------------------------------------------------------------------

