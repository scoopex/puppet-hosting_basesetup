class hosting_basesetup::unattended_upgrades (
  Boolean $reboot = false,
  String $reboot_time = 'now',
  Array[String] $blacklist = [],
  Integer $random_sleep = 1800,
  Boolean $enable,
) {
  case $::operatingsystem {
    'ubuntu', 'debian' : {
        if $enable {
          $enable_final = 1
        }else{
          $enable_final = 0
        }
        class { 'unattended_upgrades':
          enable => $enable_final,
          auto => { 
            'reboot' => $reboot,
            'reboot_time' => $reboot_time,
          },
          age => { 'max' => 10 },
          blacklist => $blacklist,
          mail => {
            only_on_error => true,
            to => $::hosting_basesetup::mail_root_recipient,
          },
          random_sleep => $random_sleep,
        } 
    }
    'Centos' : {
      fail("unsupported os: ${::operatingsystem}")
    }
    default  : {
      fail("unsupported os: ${::operatingsystem}")
    }
  }

}
