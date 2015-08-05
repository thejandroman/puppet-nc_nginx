# == Class nc_nginx::params
#
# This class is meant to be called from nc_nginx.
# It sets variables according to platform.
#
class nc_nginx::params {
  $install_dir = '/srv/www'
  $git_version = 'installed'
  $manage_git  = true
  $port        = 8000
  $repo        = 'https://github.com/puppetlabs/exercise-webpage.git'

  case $::osfamily {
    'Debian': {
      $user = 'www-data'
    }
    'RedHat', 'Amazon': {
      $user = 'nginx'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
