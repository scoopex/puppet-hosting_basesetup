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

describe command('sed "~s,^0 3 \* \* \* root,,;~s,2>&1.*,," /etc/cron.d/lvm_snapshot__dev_vg0_lv-foo|grep -v "#"|bash') do
   its(:stderr) { should match(/ERROR: this is not a logical volume/) }
end

describe command('sed "~s,^0 3 \* \* \* root,,;~s,2>&1.*,," /etc/cron.d/lvm_snapshot_the_job|grep -v "#"|bash') do
   its(:stderr) { should match(/ERROR: this is not a logical volume/) }
end

#----------------------------------------------------------------------

