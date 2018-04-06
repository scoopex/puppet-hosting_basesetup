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

describe command('su -c "/bin/echo  \$http_proxy" - user1') do
   its(:stdout) { should match(/8.8.8.8:8888/) }
end


describe command('su -c "/bin/echo  \$https_proxy" - user1') do
   its(:stdout) { should match(/8.8.8.8:8888/) }
end

#----------------------------------------------------------------------

