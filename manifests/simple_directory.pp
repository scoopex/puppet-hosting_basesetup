define hosting_basesetup::simple_directory (
  String $filename = $title,
  String $ensure   = 'directory',
  String $owner    = 'root',
  String $group    = 'root',
  String $mode     = '0700',
) {
  file { $filename:
    ensure => $ensure,
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }
}
