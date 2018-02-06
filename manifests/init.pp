# == Class: hosting_basesetup::init
#
# Installs a a basic hosting quality setup
#
# === Parameters
#
# [manage_puppet]
#   Decide to manage puppet by puppet (true/false)
#
# [users]
#   A hashmap which defines a collection of users, check hosting_basesetup::usermanagement::user
#   for details
#
# [groups]
#   A hashmap which defines a collection of users, check hosting_basesetup::usermanagement::group
#   for details
#
# [ntp_server]
#   A array of ntp servers, soecify at least 3 server
#   (if you have two watches, which one displays the correct time :-))
# 
# [mosh]
#   decide to install the mosh shell or not (true/false)
# 
# [mail_relayhost]
#   a relayhost for the local postfix installation.
#   locally queued mail will be deliver to this host, if this variable is not specified
#   delivery will be perfomed directly
#
# 



class hosting_basesetup (
  Boolean $manage_puppet = true,
  String $rootpwhash,
  Hash $users            = {},
  Hash $groups           = {},
  Array[String] $ntp_servers = ['ptbtime1.ptb.de', 'ptbtime2.ptb.de', 'ptbtime3.ptb.de',],
  Boolean $mosh = false,
  String $mail_relayhost = '',
  String $mail_root_recipient,
  String $mail_domain,
  Boolean $unattended_upgrades = true,
  Boolean $unattended_upgrades_reboot = false,
  String $unattended_upgrades_reboot_time = 'now',
  Array[String] $unattended_upgrades_blacklist = [],
  Integer $unattended_upgrades_random_sleep = 1800,
  String $motd_template    = "hosting_basesetup/motd.erb",
  String $motd_description = "<no description>",) {

  #fail("OOOPS ${hosting_basesetup::test}")

  ## RESSOURCE ORDERING ##################################################################
  #class { '::ssh_hardening::client': } ->
  #class { '::ssh_hardening::server': }

  ## KERNEL ##############################################################################
  include ::hosting_basesetup::kernel

  ## MOTD ################################################################################
  file { '/etc/motd':
    ensure  => file,
    content => template($motd_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  ## SSH #################################################################################
  class{'::ssh':
    ssh_config_forward_agent => 'no',
    sshd_config_permitemptypasswords => 'no',
    sshd_password_authentication => 'no',
    sshd_allow_tcp_forwarding => 'no',
    sshd_x11_forwarding => 'no',
    sshd_config_use_dns => 'no',
    sshd_config_challenge_resp_auth => 'no',
    sshd_use_pam  => 'yes',
    sshd_config_ciphers => [ 'aes256-ctr','aes192-ctr','aes128-ctr' ],
    sshd_ignoreuserknownhosts => 'yes',
    sshd_kerberos_authentication => 'no',
    sshd_config_kexalgorithms => [ 'diffie-hellman-group-exchange-sha256' ],
    sshd_config_loglevel => 'VERBOSE', 
    sshd_config_login_grace_time => '30s',
    sshd_config_macs => [ 'hmac-sha2-512', 'hmac-sha2-256', 'hmac-ripemd160'],
    sshd_config_maxauthtries => 2,
    sshd_config_maxsessions => 10,
    sshd_config_maxstartups => '10:30:100',
    sshd_config_strictmodes => 'yes',
    sshd_config_use_privilege_separation => 'sandbox',
    permit_root_login => 'without-password',
  }

  if $mosh {
    ensure_packages(['mosh',], {
      'ensure' => 'present'
      }
    )
  }

  ## TIME ################################################################################
  class { '::hosting_basesetup::time':
    ntp_servers => $ntp_servers,
  }

  ## POSTFIX #############################################################################
  class { 'postfix':
    inet_interfaces     => '127.0.0.1',
    smtp_listen         => '127.0.0.1',
    # inet_interfaces => '127.0.0.1, [::1]',
    # smtp_listen => '127.0.0.1, [::1]',
    myorigin            => $mail_domain,
    root_mail_recipient => $mail_root_recipient,
    relayhost           => $mail_relayhost,
  }

  ## USERMANAGEMENT ######################################################################
  class { '::hosting_basesetup::usermanagement':
    groups     => $groups,
    users      => $users,
    rootpwhash => $rootpwhash,
  }

  ## SOFTWARE ############################################################################
  class { '::hosting_basesetup::packages':
  }

  ## MONITORING ##########################################################################
  class { '::hosting_basesetup::monitoring':
  }
  ## PUPPET AGENT ########################################################################
  if $manage_puppet {
     class { '::puppet_agent':
     }
  }
  ## LVM #################################################################################
  include ::lvm

  ## APT #################################################################################
  include apt

  ## UNATTENDED UPGRADES #################################################################
  if $unattended_upgrades {
    class { '::hosting_basesetup::unattended_upgrades':
     reboot => $unattended_upgrades_reboot,
     reboot_time => $unattended_upgrades_reboot_time,
     blacklist => $unattended_upgrades_blacklist,
     random_sleep => $unattended_upgrades_random_sleep,
    }
  }
  ## CRON AND AT #########################################################################
  include hosting_basesetup::cron_at
}
