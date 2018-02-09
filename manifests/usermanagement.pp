# == Class: hosting_basesetup::usermanagement
#
class hosting_basesetup::usermanagement (
  Hash $users                  = {},
  Hash $groups                 = {},
  String $rootpwhash,
  Array[String] $ssh_keys_root          = [],
  String $root_dotfile_sourcedir = 'puppet:///modules/hosting_basesetup/dotfiles_default/',)
  {


  # Drop all files which are not managed by puppet
  file { '/etc/sudoers.d/':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    backup  => false,
    recurse => true,
    purge   => true,
  }

  hosting_basesetup::usermanagement::group { "root": gid => 0, }

  hosting_basesetup::usermanagement::user { "root":
    group_primary     => 'root',
    groups            => ['root'],
    homedir_base      => '',
    ssh_keys          => $ssh_keys_root,
    uid               => 0,
    fullname          => 'root',
    generic_profile   => true,
    passwordhash      => $rootpwhash,
    dotfile_sourcedir => $root_dotfile_sourcedir,
  }

  create_resources("hosting_basesetup::usermanagement::group", $groups)
  create_resources("hosting_basesetup::usermanagement::user", $users)
}
