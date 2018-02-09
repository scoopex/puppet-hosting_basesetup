# This file is only used for testing purposes

##################################################
# ### MOCK CLASSES WHICH SHOULD NOT TESTED HERE
class hosting_basesetup2 (
  Hash $config = {
  }
  ,) {
  notice('mocked class ==> bastion_host::foobar')
}

# INCLUDE THE CLASS
include ::hosting_basesetup

file { "/etc/sudoers.d/vagrant":
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => "
vagrant ALL=(ALL) NOPASSWD:ALL
ubuntu ALL=(ALL) NOPASSWD: ALL
debian ALL=(ALL) NOPASSWD: ALL
centos ALL=(ALL) NOPASSWD: ALL
"
}

