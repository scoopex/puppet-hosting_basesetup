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

describe command('cat /home/user1/.ssh/authorized_keys ') do
   its(:stdout) { should match(/^ssh-rsa .*foo2@bar.de$/) }
end

describe command('cat /root/.ssh/authorized_keys ') do
   its(:stdout) { should_not match(/^ssh-rsa .*foo2@bar.de$/) }
end

describe command('id user1') do
   its(:stdout) { should match(/uid=5000\(user1\) gid=8000\(devteam\) groups=8000\(devteam\)/)}
end
describe command('id user2') do
   its(:stdout) { should match(/uid=5001\(user2\) gid=8000\(devteam\) groups=8000\(devteam\)/)}
end
describe command('id root') do
   its(:stdout) { should match(/uid=0\(root\) gid=0\(root\) groups=0\(root\)/)}
end


#----------------------------------------------------------------------
