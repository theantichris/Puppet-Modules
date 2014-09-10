class nginx($webRoot = '/vagrant/web') {
  exec {
    'download-nginx-key':
    command => 'wget http://nginx.org/keys/nginx_signing.key',
    unless => 'grep -rl "deb http://nginx.org/packages/ubuntu/ trusty nginx" /etc/apt/sources.list',
    require => Package['python-software-properties'],
  }

  exec {
    'add-nginx-key':
    command => 'sudo apt-key add nginx_signing.key',
    unless => 'grep -rl "deb http://nginx.org/packages/ubuntu/ trusty nginx" /etc/apt/sources.list',
    require => Exec['download-nginx-key']
  }

  exec {
    'add-nginx-repo':
    command => 'sudo add-apt-repository "deb http://nginx.org/packages/ubuntu/ trusty nginx"',
    unless => 'grep -rl "deb http://nginx.org/packages/ubuntu/ trusty nginx" /etc/apt/sources.list',
    require => Exec['add-nginx-key'],
    notify => Exec['update-for-repo']
  }

  package {
    'nginx':
    ensure => present,
    require => Exec['add-nginx-repo', 'update-for-repo'],
  }

  service {
    'nginx':
    ensure => running,
    require => Package['nginx'],
  }

  # Create the web root folder.
  file {
    "${webRoot}":
    ensure => directory,
  }

  # Create the default virtual host file from the module.
  file {
    '/etc/nginx/conf.d/default.conf':
    ensure => present,
    source => 'puppet:///modules/nginx/default.conf',
    notify => Service['nginx'],
    require => Package['nginx'],
  }
}