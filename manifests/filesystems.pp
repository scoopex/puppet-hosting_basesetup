class hosting_basesetup::filesystems (
  String $fstrim_cron_pattern       = "0 11 * * 0",
  Integer $fstrim_randomize_seconds = 14400,
  Boolean $fstrim_enable            = true,
  Hash $federal_admin_reserve_banks = {},
) {
  file { '/usr/local/bin/nextcloud_public_folder_upload':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/hosting_basesetup/nextcloud_public_folder_upload',
  }

  if $facts['os']['name'] == "Ubuntu" and $facts['os']['release']['full'] == "18.04" {
    service { 'fstrim.timer':
      ensure => stopped,
      enable => false,
    }
  }
  elsif $facts['os']['name'] == "Ubuntu" and $facts['os']['release']['full'] == "16.04" {
    file_line { 'disable_default_fstrim':
      path  => '/etc/cron.weekly/fstrim',
      line  => "# /sbin/fstrim --all || true # disabled by puppet",
      match => '.*/sbin/fstrim',
    }
  }
  else {
    fail("unsupported os: ${::operatingsystem}")
  }

  if $fstrim_enable {
    file { '/usr/local/sbin/fstrim_cron':
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => 'puppet:///modules/hosting_basesetup/fstrim_cron',
    }
    file { '/etc/cron.d/fstrim_cron':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "# created by puppet
${fstrim_cron_pattern} root /usr/local/sbin/fstrim_cron ${fstrim_randomize_seconds} 2>&1 |logger -t fstrim_cron
",
    }
  }else {
    file { '/etc/cron.d/fstrim_cron':
      ensure => absent,
    }
  }

  create_resources("hosting_basesetup::federal_admin_reserve_bank", $federal_admin_reserve_banks)
}
