define hosting_basesetup::usermanagement::user (
  String $username             = $title,
  String $group_primary,
  String $homedir_base         = "/home",
  Array[String] $groups               = [],
  Array[String] $ssh_keys             = [],
  Integer $uid,
  String $fullname,
  String $ensure               = present,
  Boolean $generic_profile      = true,
  String $passwordhash         = '*',
  String $mail                 = 'Unknown mailadress',
  String $shell                = '/bin/bash',
  String $dotfile_sourcedir    = 'puppet:///modules/hosting_basesetup/dotfiles_default/',
  Array[String] $host_regexes_include = [".*"],
  Array[String] $host_regexes_exclude = [],) {
  user { $username:
    ensure     => $ensure,
    uid        => $uid,
    gid        => $group_primary,
    groups     => $groups,
    shell      => '/bin/bash',
    managehome => true,
    home       => "${homedir_base}/${username}",
    require    => Group[$group_primary],
    password   => $passwordhash,
    comment    => "${username}, ${fullname}",
  } ->
  file { "${homedir_base}/${username}/.ssh":
    ensure => 'directory',
    owner  => $username,
    group  => $group_primary,
    mode   => '0700',
  } ->
  file { "${homedir_base}/${username}/.ssh/authorized_keys":
    ensure  => $ensure,
    owner   => $username,
    group   => $group_primary,
    mode    => '0600',
    backup  => false,
    content => template("hosting_basesetup/authorized_keys.erb"),
  }

  file { "/home/${username}/":
    path    => "${homedir_base}/${username}/",
    ensure  => directory,
    owner   => $username,
    group   => $group_primary,
    source  => $dotfile_sourcedir,
    backup  => false,
    require => User[$username],
    recurse => true,
  }

}
