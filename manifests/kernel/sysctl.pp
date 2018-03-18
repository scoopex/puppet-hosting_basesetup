class hosting_basesetup::kernel::sysctl (
  String  $filename                       = '/etc/sysctl.conf',
  Hash    $config                         = $::hosting_basesetup::kernel::sysctl_config,
  Boolean $enable_fastnetworking_defaults = $::hosting_basesetup::kernel::sysctl_enable_fastnetworking_defaults,
  Boolean $enable_tcp_timeout_optimzation = $::hosting_basesetup::kernel::sysctl_enable_tcp_timeout_optimzation,
  Boolean $ignore_defaults                = $::hosting_basesetup::kernel::sysctl_ignore_defaults,
) {

  # Sysctl reload
  file { 'sysctl_conf':
    name => $filename,
  }

  exec { 'sysctl_file_load':
    command     => 'sysctl -p',
    refreshonly => true,
    subscribe   => File['sysctl_conf'],
    path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  }

  # Makes only sense on webservers/application servers where drastic reboot helps to get rid of performance problems
  # 'vm.panic_on_oom'=> { 'value'=> '1' } ,
  $stdkernel = {
    'kernel.panic'         => { 'value' => '30' },
    'kernel.panic_on_oops' => { 'value' => '30' },
    'vm.swappiness'        => { 'value' => '1' },
    'fs.aio-max-nr'        => { 'value' => '262144' },
    'fs.file-max'          => { 'value' => '1000000' },
    'kernel.pid_max'       => { 'value' => '4194303' },
    'vm.zone_reclaim_mode' => { 'value' => '0' },
  }

  #################################################################################
  # TCP TIMEOUT Optimization
  # During low traffic intervals, a firewall configured with an idle connection
  # timeout can close connections to local nodes and nodes in other data centers.
  if $enable_tcp_timeout_optimzation {
    $tcp_timout_optimization_defaults = {
      'net.ipv4.tcp_keepalive_time'   => { 'value' => '60' },
      'net.ipv4.tcp_keepalive_probes' => { 'value' => '3' },
      'net.ipv4.tcp_keepalive_intvl'  => { 'value' => '10' },
    }
  }else {
    $tcp_timout_optimization_defaults = {
    }
  }

  #################################################################################
  # Settings for 10G NIC/fast networks, optimized for network paths up to 100ms RTT,

  if $enable_fastnetworking_defaults {
    notice("Enabling networking settings for 10g equipment")
    $fastnetworking_defaults = {
      'net.core.netdev_max_backlog' => { 'value' => '30000' },
      'net.core.rmem_default'       => { 'value' => '16777216' },
      'net.core.wmem_default'       => { 'value' => '16777216' },
      'net.core.rmem_max'           => { 'value' => '16777216' },
      'net.core.wmem_max'           => { 'value' => '16777216' },
      'net.ipv4.tcp_rmem'           => { 'value' => '4096 87380 16777216' },
      'net.ipv4.tcp_wmem'           => { 'value' => '4096 65536 16777216' },
      'net.ipv4.tcp_syncookies'     => { 'value' => '1' },
      'net.ipv4.tcp_mtu_probing'    => { 'value' => '1' },
      'net.core.optmem_max'         => { 'value' => '40960' },
    }
  } else {
    $fastnetworking_defaults = {
    }
  }

  #################################################################################
  # Combine and create ressources
  
  if $ignore_defaults {
    $config_final = $sysctl_config
  } else {
    $config_final = deep_merge(
      $stdkernel,
      $config,
      $fastnetworking_defaults,
      $tcp_timout_optimization_defaults
    )
  }
  create_resources('hosting_basesetup::kernel::sysctl_item', $config_final)
}
