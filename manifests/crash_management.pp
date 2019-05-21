class hosting_basesetup::crash_management (
  Boolean $disable = true,
){
  if $facts['os']['name'] == "Ubuntu" and $disable {
    service { 'apport-dispatcher':
        ensure => stopped,
        enable => false,
    }
    file { "/etc/default/apport":
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => '# disabled by puppet
# set this to 0 to disable apport, or to 1 to enable it
# you can temporarily override this with
# sudo service apport start force_start=1
enabled=0
      ',
    }

  }
}