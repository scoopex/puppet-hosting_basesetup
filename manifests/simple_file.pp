define hosting_basesetup::simple_file (
  String $filename = $title,
  Hash   $config,
  String $template,
  String $owner    = 'root',
  String $group    = 'root',
  String $mode     = '0600',
  Boolean $backup  = false,
  String $ensure   = present,
) {

  file { $filename:
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    backup  => $backup,
    content => template($template),
  }
}
