class hosting_basesetup::time (
  Array[String] $ntp_servers,
  Boolean $install_rng                = true,
  Array[String] $ntp_client_restricts = [],
) {

  # TODO: https://support.ntp.org/bin/view/Support/AccessRestrictions
  $ntp_server_restricts = $ntp_servers.map |$server| {
    "${server} nomodify notrap nopeer noquery"
  }

  $ntp_restrict_final = concat($ntp_client_restricts, $ntp_server_restricts)

  class { 'ntp':
    servers  => $ntp_servers,
    restrict => flatten(['default ignore', '-6 default ignore', '127.0.0.1', '-6 ::1',
      $ntp_restrict_final, ])
  }

  # rng-tools (entropy gatherer)
  if $::is_virtual and $install_rng {
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
      hasrestart => true,
    }
  }
}
