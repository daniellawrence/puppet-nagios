# nrpe::command
# setup a check_command in nrpe on the client machines
define nagios::nrpe::command ($check_command) {

  File <| tag == 'nrpe' |>
  Package <| tag == 'nrpe' |>
  Service <| tag == 'nrpe' |>

  file { "/etc/nagios/nrpe.d/${name}.cfg":
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
    content => template('nagios/nrpe_command.erb');
  }

}
