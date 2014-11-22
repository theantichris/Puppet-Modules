class mongodb {
  exec {
    'import mongodb public key':
      command => 'sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10',
      unless  => "apt-key list | grep 7F0CEB10",
      require => Exec['install packages'],
  }

  exec {
    'add mongodb repo':
      command  => "echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list && sudo apt-get update",
      creates  => '/etc/apt/sources.list.d/mongodb.list',
      require  => Exec['import mongodb public key'],
  }

  package {
    ['mongodb-org', 'php5-mongo']:
      ensure  => present,
      require => Exec['add mongodb repo'],
  }

  service {
    'mongod':
      ensure  => running,
      require => Package['mongodb-org']
  }
}