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

describe command('su -c "crontab /etc/fstab" - user1') do
   its(:stderr) { should match(/You .* are not allowed to use this program/) }
end

describe command('su -c "echo \'1 1 1 1 1 /bin/ls\'|crontab" - user2') do
   its(:exit_status) { should eq 0 }
end

describe command('su -c "echo \'1 1 1 1 Q /bin/ls\'|crontab" - user2') do
   its(:exit_status) { should eq 1 }
end


#----------------------------------------------------------------------

