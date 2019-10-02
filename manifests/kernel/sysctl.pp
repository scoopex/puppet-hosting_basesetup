class hosting_basesetup::kernel::sysctl (
  String  $filename                                   = '/etc/sysctl.conf',
  Hash    $config                                     = $::hosting_basesetup::kernel::sysctl_config,
  Boolean $enable_fastnetworking_defaults             =
    $::hosting_basesetup::kernel::sysctl_enable_fastnetworking_defaults,
  Boolean $enable_lowlatencynetworking_defaults       =
    $::hosting_basesetup::kernel::sysctl_enable_lowlatencynetworking_defaults,
  Boolean $enable_tcp_timeout_optimzation             =
    $::hosting_basesetup::kernel::sysctl_enable_tcp_timeout_optimzation,
  Boolean $enable_automatic_reboot_on_kernel_problems =
    $::hosting_basesetup::kernel::sysctl_enable_automatic_reboot_on_kernel_problems,
  Boolean $ignore_defaults                            = $::hosting_basesetup::kernel::sysctl_ignore_defaults,

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
    'vm.swappiness'        => { 'value' => '1' },
    'fs.aio-max-nr'        => { 'value' => '262144' },
    'fs.file-max'          => { 'value' => '1000000' },
    'kernel.pid_max'       => { 'value' => '4194303' },
    'vm.zone_reclaim_mode' => { 'value' => '0' },
  }

  #################################################################################
  # Automatic reboot on critical problems

  if $enable_automatic_reboot_on_kernel_problems {
    $automatic_reboot_on_kernel_problems = {
      'kernel.panic'         => { 'value' => '30' },
      'kernel.panic_on_oops' => { 'value' => '30' },
      #'vm.panic_on_oom'      => { 'value' => '1' },

    }
  }else {
    $automatic_reboot_on_kernel_problems = {
      'kernel.panic'         => { 'value' => '0' },
      'kernel.panic_on_oops' => { 'value' => '0' },
      #'vm.panic_on_oom'      => { 'value' => '0' },
    }
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
      'net.core.somaxconn'           => { 'value' => '1024' },    # ori 128
      'net.core.netdev_max_backlog'  => { 'value' => '250000' },
      'net.core.rmem_default'        => { 'value' => '134217728' },
      'net.core.wmem_default'        => { 'value' => '134217728' },
      'net.core.rmem_max'            => { 'value' => '134217728' },
      'net.core.wmem_max'            => { 'value' => '134217728' },
      'net.core.optmem_max'          => { 'value' => '40960' },
      'net.ipv4.tcp_rmem'            => { 'value' => '4096 87380 67108864' },
      'net.ipv4.tcp_wmem'            => { 'value' => '4096 65536 67108864' },
      'net.ipv4.tcp_syncookies'      => { 'value' => '1' },
      'net.ipv4.tcp_mtu_probing'     => { 'value' => '1' },
      'net.ipv4.tcp_max_syn_backlog' => { 'value' => '30000' },   # ori 2048
      'net.ipv4.tcp_max_tw_buckets'  => { 'value' => '2000000' }, # ori 262144
      'net.ipv4.tcp_tw_reuse'        => { 'value' => '1' },       # ori 1
      'net.ipv4.tcp_fin_timeout'     => { 'value' => '10' },      # ori 60
    }
  } else {
    $fastnetworking_defaults = {
    }
  }

  #################################################################################
  # Settings for Low Latency Networking (latency vs. throughput)

  if $enable_lowlatencynetworking_defaults {
    notice("Enabling low latency networking settings")
    $lowlatencynetworking_defaults = {
      'net.ipv4.tcp_timestamps'     => { 'value' => '0' },
      'net.ipv4.tcp_low_latency'    => { 'value' => '1' },
    }
  } else {
    $lowlatencynetworking_defaults = {
    }
  }


  #################################################################################
  # Combine and create ressources

  if $ignore_defaults {
    $config_final = $config
  } else {
    $config_final = deep_merge(
      $stdkernel,
      $config,
      $fastnetworking_defaults,
      $lowlatencynetworking_defaults,
      $tcp_timout_optimization_defaults,
      $automatic_reboot_on_kernel_problems,
    )
  }
  create_resources('hosting_basesetup::kernel::sysctl_item', $config_final)
}
