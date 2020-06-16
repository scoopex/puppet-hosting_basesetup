define hosting_basesetup::federal_admin_reserve_bank (
  Enum['present', 'absent'] $ensure = present,
  String $path                      = $title,
  Integer $size_mb                  = 1024,
  Integer $timeout                  = 900,
) {
  if $ensure == "present" {
    $federal_res = "$path/FEDERAL_ADMIN_RESERVE_BANK"
    exec { $federal_res:
      command => "dd if=/dev/zero of=${federal_res} bs=1M count=${size_mb}",
      creates => $federal_res,
      path    => '/usr/bin:/usr/sbin:/bin',
      unless  => "test -f ${federal_res}",
      require => Class["hosting_basesetup::lvm"],
      timeout => $timeout,
    }
    -> file { $federal_res:
      owner => 'root',
      group => 'root',
      mode  => '0644',
    }
  }
  else {
    file { $federal_res:
      ensure => absent,
    }
  }
}
