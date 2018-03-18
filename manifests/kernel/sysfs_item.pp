
define hosting_basesetup::kernel::sysfs_item(
  String $type = "",
  NotUndef $base,
  Hash $config,
) {


  if $type !~ /^(mode|owner|)$/ {
    fail("Specify mode, owner or nothing fpr \$type")
  }

  if $type != "" {
    $prefix_final = "${type} "
  }else{
    $prefix_final = ""
  }

  $base_arr_final = unique(any2array($base))

  case $::operatingsystem {
    'ubuntu', 'debian': {
      file { "/etc/sysfs.d/hosting_basesetup_sysfs_item_${title}.conf":
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("hosting_basesetup/sysfs_item.conf.erb"),
        notify => Service['sysfsutils'],
      }
    }
    'Centos': {
      fail("unsupported os: ${::operatingsystem}")
    }
    default: {
      fail("unsupported os: ${::operatingsystem}")
    }
  }


}