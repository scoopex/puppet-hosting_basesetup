Overview
--------

This project implements a basic system setup for the following platforms:

* Ubuntu 16.04 LTS (tested by spectests)
* Debian Strech (tested by spectests)
* Centos 7 (uncomplete)

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

* Disk Device Settings (Cassandra)
  * Configure readahead for ssds/disks
    ```
    echo 8 > /sys/class/block/sda/queue/read_ahead_kb
    blockdev --setra 128
    ```
  * Configure Scheduler (Cassandra)
    ```
    echo deadline > /sys/block/sda/queue/scheduler
    ```
  * Rotational (Cassandra)
    ```
    echo 0 > /sys/class/block/sda/queue/rotational
    ```
* zone_reclaim_mode on NUMA systems (Cassandra)
  ```
    echo 0 > /proc/sys/vm/zone_reclaim_mode
  ```
* Hugepage defrag (Cassandra)
  ```
  echo never | sudo tee /sys/kernel/mm/transparent_hugepage/defrag
  ```

* SMART Daemon on non virtualized hardware systems
* systemd journal configuration (housekeeping, permissions)
  https://www.freedesktop.org/software/systemd/man/journald.conf.html
  /etc/systemd/journald.conf
* blockdevice parameters<BR>
  (Scheduler, Readahead, ...)
  udevadm info -a -p /sys/block/sda
  https://unix.stackexchange.com/questions/71364/persistent-blockdev-setra-read-ahead-setting
* virtual serial consoles for server systems
  => to support connect by virtual serial console by IPMI
* IPTables base setup for ipv4/ipv6, https://github.com/puppetlabs/puppetlabs-firewall
  * restrict for inbound everything except ssh
  * restrict outbound except essential os parameters
  * use groups of systems
* (default) filesystemparameters
* configure network interfaces
* IPMI Watchdog
* configure lvm volumes, groups
* network tuning
  (Port Ranges, Socket Buffers, tcp_sack, tcp_timestamps )
* reduce deprecation warnings of used modules
* sepcify exact versions for dependencies
* use hiera data in module for distibution specific parameters
* use testinfra as testing framework
  https://testinfra.readthedocs.io/en/latest/
* Increase memory of vagrant/kitchen vms or reduce memory consumption (32bit vms) for complexer setups
* install and configure puppet final agent config<BR>
  (provide capability to switch environment)
* logshipping to syslog
* logstash/graylog support
* aide intrusion detection

Contribution
------------

 * file a bug on the github project: https://github.com/scoopex/puppet-hosting_basesetup/issues
 * fork the project and improve the template
 * create a pull/merge request

