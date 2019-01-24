define hosting_basesetup::lvm_snapshot_job (
  String $lvm_snapshot_job    = $title,
  String $cron_timespec       = "0 3 * * *",
  Boolean $snap_create        = true,
  String  $snap_size          = "10%",
  Boolean $snap_delete        = true,
  Integer $snap_generations   = 3,
  Float $snap_max_alloc_limit = 90.0,
  Boolean $zabbix_notify      = false,
  String $ensure              = present,
  Array[String] $lvs          = [],
) {

  $title_simple = regsubst($title, '/', '_', 'G')

  if length($lvs) == 0 {
    $lvs_real = $title
  }else {
    $lvs_real = join($lvs, ' ')
  }

  if $zabbix_notify {
    $zabbix = "--zabbix_notify"
  }else {
    $zabbix = ""
  }

  if $snap_create {
    $snap = "--snap --lv_size '${snap_size}'"
  }else {
    $snap = ""
  }

  if $snap_delete {
    $purge = "--delete_snaps --max_snaps $snap_generations "
  }else {
    $purge = ""
  }

  file { "/etc/cron.d/lvm_snapshot_${title_simple}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "# created by puppet
${cron_timespec} root /usr/local/sbin/manage_lvm_snapshots ${snap} ${purge} ${zabbix} ${lvs_real} --snap_max_alloc_limit ${snap_max_alloc_limit} 2>&1|logger -t lvm_snapshot
",
  }
}
