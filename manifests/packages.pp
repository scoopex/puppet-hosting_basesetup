class hosting_basesetup::packages (
  Array[String] $override = [],
  Boolean $use_defaults   = true,
) {

  case $::operatingsystem {
    'ubuntu', 'debian': {
      $packages = [
        'apt-transport-https', 'bash-completion', 'curl', 'wget', 'htop', 'iftop',
        'iptraf-ng', 'pv', 'lsscsi', 'dialog', 'ncdu', 'scsitools', 'sysstat', 'xfsdump',
        'xfsprogs', 'zip', 'git', 'tig', 'vim', 'finger', 'mailutils', 'traceroute',
        'net-tools', 'lvm2', 'strace', 'sysfsutils'
      ]
    }
    'Centos': {
      $packages = [
        'curl', 'wget', 'iptraf-ng', 'lsscsi', 'sysstat', 'xfsdump', 'xfsprogs', 'zip',
        'git-all', 'vim-enhanced', 'finger', 'traceroute', 'net-tools', 'lvm2', 'strace',
        'sysfsutils'
      ]
      # 'iftop', 'ncdu', 'scsitools', 'pv', 'tig', 'mailutils', 'htop',
    }
    default: {
      fail("unsupported os: ${::operatingsystem}")
    }
  }


  if $use_defaults {
    $default_packages = $packages
  }else{
    $default_packages = []
  }

  $packages_final = union($default_packages, $override)

  ensure_packages($packages_final)

  case $::operatingsystem {
    'ubuntu', 'debian': {
      exec { 'update-alternatives --set editor /usr/bin/vim.basic':
        path    => '/bin:/sbin:/usr/bin:/usr/sbin',
        unless  => 'test /etc/alternatives/editor -ef /usr/bin/vim.basic',
        require => Package['vim'],
      }
    }
  }
}

