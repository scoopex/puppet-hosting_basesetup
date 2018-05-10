
# Make the os dns resolver more reliable
# (faster timeouts, round robin
class hosting_basesetup::dns () {

  if $facts['os']['name'] == "Ubuntu" and $facts['os']['release']['full'] == "16.04" {
    file { '/etc/resolvconf/resolv.conf.d/base':
      ensure  => file,
      content => "# created by puppet, see man resolv.conf
options timeout:1 attempts:1 rotate
        ",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
    service { 'resolvconf':
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      subscribe  => File['/etc/resolvconf/resolv.conf.d/base'],
    }
  } elsif $facts['os']['name'] == "Ubuntu" and $facts['os']['release']['full'] == "18.04" {
    notice("dns resolver configuration not needed here")
  }else {
    notice("dns resolving configuration not implemented")
  }
}