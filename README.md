Overview
--------

This project implements a basic system setup for the following platforms:

* Ubuntu 16.04 LTS (tested by spectests)
* Ubuntu 18.04 LTS (tested by spectests)
* Debian Strech (tested by spectests)
* Centos 7
  * implementation not complete
  * contributions are very welcome<br>
    (just fix the code/tests and submit pull requests)
  * needs to be implemented:
     * sysfs settings
     * unattended os updates
     * kernel parameters

This setup can be used as a base for server systems.
The setup ist tested by using test-kitchen and serverspec tests.
(for Details, review the [Documentation of the test setup](README_Test_Environment.mf))

Things implemented with this setup
----------------------------------

* motd generation by template
* basic sysctl kernel settings
  * 10g networking
  * oops-behavior, swappiness, ...
  * custom systctl settings via hiera
  * maximum number of processes and file descriptors
  * zone_reclaim_mode on NUMA systems
  * disable transparent hugepages/hugepage defrag
* sysfs settings
* hardening of openssh server/client
  * no password login
  * ciphers
  * ...
* installation of mosh shell<BR>
  (disabled by default)
* time setup
  * secure ntp setup
  * rngd, improvement of random number generator for virtual systems
* postfix mta
  * deliver mails to smarthost
  * map root mail
  * ...
* usermanagement via hiera
  * group creation
  * user creation
  * generation of sudo permisssions based on configurable templates
  * distribution of ssh keys
  * distribution of standard dotfiles
  * distribution of user specific dotfiles from a specifyable location
  * minimal numeric uids/gids at 12000 to reduce collections with groups and users id without numeric id specification
  * restrict distribution of users/groups by restriction tag 
  * override user/group details for dedicated nodes
* installation of zabbix agent
  * add additional zabbix-agent-extenion packages
* package installtion via hiera
  * numerous useful packages
  * set vim as standard editor
* lvm management via hiera<BR>
  (review https://github.com/puppetlabs/puppetlabs-lvm)
* apt source management<BR>
  https://forge.puppet.com/puppetlabs/apt
* unattended configurable os updates<BR>
  https://forge.puppet.com/puppet/unattended_upgrades
* at/cron setup
* ulimits
* grub config</BR>
  (no splash, no quiet mode)


Currently not implemented/TODOs
--------------------------------

by priority:

* finish ubuntu 18.04 support
* SMART Daemon on non virtualized hardware systems
* systemd journal configuration (housekeeping, permissions)
  https://www.freedesktop.org/software/systemd/man/journald.conf.html
  /etc/systemd/journald.conf
* IPTables base setup for ipv4/ipv6, https://github.com/puppetlabs/puppetlabs-firewall
  * restrict for inbound everything except ssh
  * restrict outbound except essential os parameters
  * use groups of systems
* (default) filesystemparameters
* configure network interfaces
* IPMI Watchdog
* enhanced network tuning
  (Port Ranges, Socket Buffers, tcp_sack, tcp_timestamps )
* reduce deprecation warnings of used puppet modules
* specify exact versions for dependencies
* use hiera data in module for distibution specific parameters
* use testinfra as testing framework
  https://testinfra.readthedocs.io/en/latest/
* install and configure puppet final agent config<BR>
  (provide capability to switch environment)
* uniq userids, do not reuse old users and groups</BR>
  * implement a pool of outdated userids, uid, gids - remove them automatically
  * remove user directories after a specified amount of days
* logshipping to syslog
* logstash/graylog support
* aide intrusion detection

Contribution
------------

 * file a bug on the github project: https://github.com/scoopex/puppet-hosting_basesetup/issues
 * fork the project and improve the template
 * create a pull/merge request

