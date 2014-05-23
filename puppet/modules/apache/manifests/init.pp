class apache {
  package {
    'apache2':
    ensure => present,
    require => Exec['update-package-list'],
  }

  service {
    'apache2':
    ensure => running,
    require => Package['apache2']
  }

  # Remove default index file.
  exec {
    'sudo rm -rf /var/www':
    path => '/usr/bin',
    require => Package['apache2']
  }

  # Symlink web root.
  file {
    '/var/www':
    ensure => link,
    target => '/vagrant/web',
    require => Exec['sudo rm -rf /var/www']
  }
}