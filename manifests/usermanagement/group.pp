define hosting_basesetup::usermanagement::group (
  String $groupname     = $title,
  Integer $gid,
  String $sudo_template = "",
  String $ensure        = present,) {
  group { $groupname:
    ensure => $ensure,
    gid    => $gid,
  }

  if $sudo_template != "" {
    file { "/etc/sudoers.d/hosting_basesetup_usermanagement_group_${groupname}":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template($sudo_template),
    }
  }
}
