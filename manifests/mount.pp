define hosting_basesetup::mount (
  String $ensure,
  String $owner = "root",
  String $group = "root",
  String $mode  = "0755",
  Boolean $atboot,
  String $device,
  String $fstype,
  String $options,
  Integer $dump = 0,
  Integer $pass = 1,
) {

  if ($fstype == "nfs") {
    # TODO: Implement IDMAP Settings
    ensure_packages(["nfs-common"], { ensure => 'present', before => Mount[$name] })
  }

  exec { "create_folder_${name}":
    path    => '/usr/bin:/usr/sbin:/bin',
    command => "mkdir $name && chmod $mode $name && chown $owner:$group $name",
    onlyif  => "test ! -d $name",
    before  => Mount[$name],
  }

  mount { $name:
    ensure  => $ensure,
    atboot  => $atboot,
    device  => $device,
    fstype  => $fstype,
    options => $options,
    dump    => $dump,
    pass    => $pass,
  }
}
