class hosting_basesetup::packages (
  Array[String] $override = [],
  Boolean $use_defaults   = true,
) {

  case $::operatingsystem {
    'ubuntu', 'debian': {
      $packages = [
        'apt-transport-https', 'bash-completion', 'curl', 'wget', 'htop', 'iftop', 'at', 
        'iptraf-ng', 'pv', 'lsscsi', 'dialog', 'ncdu', 'scsitools', 'sysstat', 'xfsdump',
        'xfsprogs', 'zip', 'git', 'tig', 'vim', 'finger', 'mailutils', 'traceroute', 'multitail',
        'net-tools', 'lvm2', 'strace', 'sysfsutils', 'screen', 'nuttcp', 'gnupg', 'nethogs', "pigz",
      ]
      if (!$::is_virtual) {
        ensure_packages(['smartmontools'], { ensure => present })
      }

    }
    'Centos': {
      $packages = [
        'curl', 'wget', 'iptraf-ng', 'lsscsi', 'sysstat', 'xfsdump', 'xfsprogs', 'zip',
        'git-all', 'vim-enhanced', 'finger', 'traceroute', 'net-tools', 'lvm2', 'strace',
        'sysfsutils', 'screen', 'nuttcp', 'gnupg',
      ]
      # 'iftop', 'ncdu', 'scsitools', 'pv', 'tig', 'mailutils', 'htop',
      if(!$::is_virtual) {
        ensure_packages(['smartmontools'], { ensure => present })
      }
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
      if defined(Package['vim']) {
        exec { 'update-alternatives --set editor /usr/bin/vim.basic':
          path    => '/bin:/sbin:/usr/bin:/usr/sbin',
          unless  => 'test /etc/alternatives/editor -ef /usr/bin/vim.basic',
          require => Package['vim'],
        }
      }
    }
  }
}

