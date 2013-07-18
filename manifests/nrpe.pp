# nrpe
# Setup the nrpe server and nagios-plugin on a client machine.
class nagios::nrpe {

  @package {
    'nagios-nrpe-server':
      ensure => present,
      tag    => 'nrpe';
    'nagios-nrpe-plugin':
      ensure => present,
      tag    => 'nrpe';
    'nagios-plugins':
      ensure => present,
      tag    => 'nrpe';
  }

  user { 'nagios':
    groups  => ['users', 'puppet'],
    require => Package['nagios-nrpe-server'],
  }

  @service { 'nagios-nrpe-server':
    ensure  => running,
    require => Package['nagios-nrpe-server'],
    tag     => 'nrpe',
  }

  @file { '/etc/nagios/nrpe.cfg':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
    content => template('nagios/nrpe.erb'),
    tag     => 'nrpe',
  }

  $plugin_dirs = ['/etc/nagios-plugins', '/etc/nagios-plugins/config']

  file { $plugin_dirs:
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }

  file{ '/etc/nagios-plugins/config/check_nrpe.cfg':
    owner   => root,
    group   => root,
    mode    => '0755',
    source  => 'puppet:///modules/nagios/check_nrpe.cfg',
    require => File[$plugin_dirs],
  }

  @file {
    '/usr/local/lib/nagios/':
      ensure  => directory,
      owner   => root,
      group   => root,
      mode    => '0755',
      tag     => 'nrpe';
    '/usr/local/lib/nagios/plugins':
      ensure  => directory,
      owner   => root,
      group   => root,
      mode    => '0755',
      require => File['/usr/local/lib/nagios/'],
      tag     => 'nrpe';
  }
}

