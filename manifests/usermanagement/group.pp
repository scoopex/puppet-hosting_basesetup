define hosting_basesetup::usermanagement::group (
  String $groupname     = $title,
  Integer $gid,
  String $sudo_template = "",
  Array[String] $restriction_tags = [],
  String $ensure        = present,) {


  if ($ensure == "present" and length($restriction_tags) > 0)
    {
    if $::hosting_basesetup::usermanagement::restriction_tag in $restriction_tags {
      $ensure_final = 'present'
    } else {
      $ensure_final = 'absent'
    }
  } else {
    $ensure_final = $ensure
  }

  group { $groupname:
    ensure => $ensure_final,
    gid    => $gid,
    require => File_Line['min_gid'],
  }

  if $sudo_template != "" {
    file { "/etc/sudoers.d/hosting_basesetup_usermanagement_group_${groupname}":
      ensure  => $ensure_final,
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
      content => template($sudo_template),
    }
  }
}
