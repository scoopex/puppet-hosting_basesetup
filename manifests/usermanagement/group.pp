define hosting_basesetup::usermanagement::group (
  String $groupname                            = $title,
  Integer $gid,
  String $sudo_template                        = "",
  Array[String] $restriction_tags              = [],
  Boolean $restriction_tags_enforce            = false,
  Enum['present', 'absent', 'defined'] $ensure = present,
) {



  if ($restriction_tags_enforce or (length($restriction_tags) > 0 and $::hosting_basesetup::usermanagement::restriction_tag != ''))
  {
    if $::hosting_basesetup::usermanagement::restriction_tag in $restriction_tags {
      $ensure_final = $ensure
    } else {
      $ensure_final = 'absent'
    }
  } else {
    $ensure_final = $ensure
  }
  if $ensure == "present" or $ensure == "defined" {
      anchor { "hosting_basesetup_group_gid_${gid}": } # prevents duplicate allocation of gids
  }
  if $ensure == "present" or $ensure == "absent" {
    group { $groupname:
      ensure  => $ensure_final,
      gid     => $gid,
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
}
