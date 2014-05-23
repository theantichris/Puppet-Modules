class mongodb {
  exec {
    'import-mongodb-public-key':
    command => 'sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10',
    unless => "apt-key list | grep 7F0CEB10",
  }

  exec {
    'add-mongodb-repo':
    command => "echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list",
    unless => 'ls /etc/apt/sources.list.d/mongodb.list',
    notify => Exec['sudo apt-get update'],
    require => Package['python-software-properties', 'python', 'g++', 'make'],
  }

  package {
    'mongodb-org':
    ensure => present,
    require => Exec['add-mongodb-repo', 'sudo apt-get update'],
  }

  service {
    'mongod':
    ensure => running,
    require => Package['mongodb-org']
  }
}