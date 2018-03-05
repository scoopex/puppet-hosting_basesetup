define hosting_basesetup::usermanagement::group (
  String $groupname     = $title,
  Integer $gid,
  String $sudo_template = "",
  String $ensure        = present,) {

  group { $groupname:
    ensure => $ensure,
    gid    => $gid,
    require => File_Line['min_gid'],
  }

  if $sudo_template != "" {
    file { "/etc/sudoers.d/hosting_basesetup_usermanagement_group_${groupname}":
      ensure  => $ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template($sudo_template),
    }
  }
}
