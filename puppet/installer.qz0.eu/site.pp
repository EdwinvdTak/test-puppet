case $operatingsystem {
  centos, redhat: { $service_name = 'ntpd' }
  debian, ubuntu: { $service_name = 'ntp' }
}

package { 'ntp':
  ensure => installed,
}

service { 'ntp':
  name      => $service_name,
  ensure    => running,
  enable    => true,
  subscribe => File['ntp.conf'],
}

$str = "driftfile /var/lib/ntp/ntp.drift\nstatistics loopstats peerstats clockstats\nfilegen loopstats file loopstats type day enable\nfilegen peerstats file peerstats type day enable\nfilegen clockstats file clockstats type day enable\nserver 0.ubuntu.pool.ntp.org\nserver 1.ubuntu.pool.ntp.org\nserver 2.ubuntu.pool.ntp.org\nserver 3.ubuntu.pool.ntp.org\nserver ntp.ubuntu.com\nrestrict -4 default kod notrap nomodify nopeer noquery\nrestrict -6 default kod notrap nomodify nopeer noquery\nrestrict 127.0.0.1\nrestrict ::1\n"

file { 'ntp.conf':
  path    => '/etc/ntp.conf',
  ensure  => file,
  require => Package['ntp'],
  content => "$str",
}
