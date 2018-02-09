class hosting_basesetup::monitoring (
  Boolean $zabbix_agent                    = true,
  String $zabbix_server                    = 'zabbix',
  String $zabbix_server_active             = 'zabbix',
  String $zabbix_listenip                  = '127.0.0.1',
  String $zabbix_hostmetadata              = 'Linux',
  Array[String] $additional_agent_packages = [],
  String $additional_agent_packages_ensure = 'installed',
) {
  if $zabbix_agent {
    class { 'zabbix::agent':
      server       => "${zabbix_server}, 127.0.0.1",
      serveractive => $zabbix_server,
      listenip     => $zabbix_listenip,
      buffersize   => 500,
      hostmetadata => $zabbix_hostmetadata,
    }
    include ::zabbix::sender
    ensure_packages(["zabbix-get"],
      {
        'require' => Class['zabbix::agent'],
      }
    )
    ensure_packages(
      $additional_agent_packages,
      {
        'ensure'  => $additional_agent_packages_ensure,
        'require' => Class['zabbix::agent'],
      }
    )
  }
}

