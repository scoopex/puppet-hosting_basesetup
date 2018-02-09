class hosting_basesetup::time (Array[String] $ntp_servers,) {
  $ntp_restrict = $ntp_servers.map |$server| {
    "${server} nomodify notrap nopeer noquery"
  }

  class { 'ntp':
    servers  => $ntp_servers,
    restrict => flatten(['default ignore', '-6 default ignore', '127.0.0.1', '-6 ::1', $ntp_restrict,])
  }

  # rng-tools (entropy gatherer)
  if $::is_virtual {
    ensure_packages(['rng-tools'], { ensure => present })

    file { '/etc/default/rng-tools':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/hosting_basesetup/etc.default.rng-tools',
      require => Package['rng-tools'],
      notify  => Service['rng-tools'];
    }

    service { 'rng-tools':
      ensure     => running,
      enable     => true,
      pattern    => 'rngd',
      hasstatus  => false,
      hasrestart => true;
    }
  }
}
