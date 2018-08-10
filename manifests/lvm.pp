class hosting_basesetup::lvm (
  Hash $snapshots,
) {

  include ::lvm

  file { '/usr/local/sbin/manage_lvm_snapshots':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      source  => 'puppet:///modules/hosting_basesetup/manage_lvm_snapshots',
  }

  tidy { '/etc/cron.d':
    matches => [ 'lvm_snapshot_*' ],
    recurse => true,
  }
  create_resources("::hosting_basesetup::lvm_snapshot_job", $snapshots)
}
