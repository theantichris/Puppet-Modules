class nginx {
  exec {
    'add-nginx-repo':
    command => 'sudo add-apt-repository ppa:nginx/stable',
    unless => 'ls /etc/apt/sources.list.d/nginx-stable-precise.list',
    notify => Exec['sudo apt-get update'],
    require => Package['python-software-properties'],
  }

  package {
    'nginx':
    ensure => present,
    require => Exec['add-nginx-repo', 'sudo apt-get update'],
  }

  service {
    'nginx':
    ensure => running,
    require => Package['nginx'],
  }

  # Create a folder in the Vagrant sync folder to link the web root too.
  file {
    '/vagrant/web':
    ensure => directory,
  }

  # Create the web root directory at /var/www and link it to the web folder.
  file {
    '/var/www':
    ensure => link,
    target => '/vagrant/web',
    require => File['/vagrant/web'],
  }

  file {
    '/var/www/index.html':
    ensure => present,
    source => 'puppet:///modules/nginx/index.html',
    require=> File['/var/www'],
  }

  # Create the default virtual host file from the module.
  file {
    '/etc/nginx/sites-available/default':
    ensure => present,
    source => 'puppet:///modules/nginx/default',
    notify => Service['nginx'],
    require => Package['nginx'],
  }
}