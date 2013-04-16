# Define: apache::vhost::redirect
#
# This class will create a vhost that does nothing more than redirect to a
# given location
#
# Parameters:
#   $port:
#       Which port to list on
#   $dest:
#       Where to redirect to
# - $vhost_name
#
# Actions:
#   Installs apache and creates a vhost
#
# Requires:
#
# Sample Usage:
#
define apache::vhost::redirect (
    $port,
    $dest,
    $priority      = '10',
    $serveraliases = '',
    $template      = 'apache/vhost-redirect.conf.erb',
    $servername    = $apache::params::servername,
    $vhost_name    = '*'
  ) {

  include apache

  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  # Setup dir to store vhost files. Debian based systems use sites-available
  if $apache::params::sdir {
    $vdir = $apache::params::sdir
  } else {
    $vdir = $apache::params::vdir
  }

  file { "${priority}-${name}.conf":
    path    => "${vdir}/${priority}-${name}.conf",
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }

  # Create symlink using a2ensite from sites-available to sites-enabled
  if $::osfamily == 'debian' {
    a2site { "${name}.conf":
      ensure   => present,
      priority => $priority,
      require  => [
        File["${priority}-${name}.conf"],
      ],
    }
  }

  if ! defined(Firewall["0100-INPUT ACCEPT $port"]) {
    @firewall {
      "0100-INPUT ACCEPT $port":
        jump  => 'ACCEPT',
        dport => '$port',
        proto => 'tcp'
    }
  }
}

