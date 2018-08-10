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

describe command('cat /etc/fstab') do
  its(:stdout) { should match(/^8.8.8.8:\/srv\/nfs\/test1\s+\/nfs1\s+nfs\s+defaults\s+0\s+2$/) }
  its(:stdout) { should match(/^8.8.8.8:\/srv\/nfs\/test2\s+\/nfs2\s+nfs\s+defaults\s+0\s+2$/) }
end


describe command('ls -ld /nfs*') do
   its(:stdout) { should match(/^drwxr-xr-x 2 root root .* \/nfs1$/) }
   its(:stdout) { should match(/^drwxr-xr-x 2 root root .* \/nfs2$/) }
end


#----------------------------------------------------------------------

