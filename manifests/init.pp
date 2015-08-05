# Class: nc_nginx
# ===========================
#
# Install and configure Nginx according to NC's requirements.
#
# Parameters
# ----------
#
# * `install_dir`
#   [ABSOLUTE_PATH] Path to directory in which to install the repo to
#   be used as the DocumentRoot for the vhost. Defaults to `/srv/www`.
#
# * `git_version`
#   [STRING] Version of git to install. Ignored if `$manage_git ==
#   false`. Defaults to `installed`.
#
# * `manage_git`
#   [BOOL] Whether to manage the installation of git. Defaults to
#   `true`.
#
# * `port`
#   [INTEGER] Port on which to serve the vhost. Defaults to `8000`.
#
# * `repo`
#   [STRING] Repo to install in `$install_dir`. It will be used as the
#   DocumentRoot for the vhost. Care should be taken if using ssh
#   based git repos as management of authorized_hosts is outside the
#   scope of this module. Defaults to
#   `https://github.com/puppetlabs/exercise-webpage.git`.
#
# * `user`
#   [STRING] User to use as the daemon user for nginx and the owner of
#   the `$install_dir`. Defaults vary according to OS; see params.pp.
#
class nc_nginx (
  $install_dir = $::nc_nginx::params::install_dir,
  $git_version = $::nc_nginx::params::git_version,
  $manage_git  = $::nc_nginx::params::manage_git,
  $port        = $::nc_nginx::params::port,
  $repo        = $::nc_nginx::params::repo,
  $user        = $::nc_nginx::params::user,
  ) inherits ::nc_nginx::params {

  # Validate inputs
  validate_absolute_path($install_dir)
  validate_bool($manage_git)
  validate_integer($port)
  validate_string($git_version, $repo, $user)

  # Install git if needed
  if $manage_git {
    package { 'git': ensure => $git_version }
    # Some git specific chaining
    Package['git'] -> Vcsrepo[$install_dir]
  }

  # Install and configure nginx
  class { '::nginx::config':
    vhost_purge => true,
    daemon_user => $user,
  }
  class { '::nginx': }

  # Install the web data
  vcsrepo { $install_dir:
    ensure   => present,
    provider => git,
    source   => $repo,
    owner    => $user,
  }

  # Create the vhost
  nginx::resource::vhost { 'nc_nginx':
    ensure      => present,
    listen_port => $port,
    www_root    => $install_dir,
  }

  # Some chaining
  Package['nginx'] -> Vcsrepo[$install_dir] ~> Service['nginx']
}
