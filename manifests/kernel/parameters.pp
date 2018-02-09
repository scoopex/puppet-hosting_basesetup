class hosting_basesetup::kernel::parameters () {

  #if $::is_virtual {}
  # GRUB_CMDLINE_LINUX_DEFAULT="console=tty1 console=ttyS0"
  case $::operatingsystem {
    'ubuntu', 'debian' : {
        augeas{ 'set_kernel_opts':
          context =>  '/files/etc/default/grub',
          changes =>  "set GRUB_CMDLINE_LINUX_DEFAULT '\"${hosting_basesetup::kernel::boot_options}\"'",
          notify => Exec['update-grub']
        }
        exec { "update-grub":
          user   => 'root',
          path   => '/usr/bin:/usr/sbin:/bin',
          refreshonly => true,
        }
    }
    'Centos' : {
      fail("unsupported os: ${::operatingsystem}")
    }
    default  : {
      fail("unsupported os: ${::operatingsystem}")
    }
  }

  ############################################################################################################


}
