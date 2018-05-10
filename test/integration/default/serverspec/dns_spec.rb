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

describe command('nslookup www.github.com') do
   its(:exit_status) { should eq 0 }
end


#----------------------------------------------------------------------

