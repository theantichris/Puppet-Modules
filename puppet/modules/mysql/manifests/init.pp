class mysql($rootUsername = 'root', $rootPassword = '123', $databaseName = 'database_dev') {
  file {
    '/etc/mysql':
      ensure => directory,
  }

  file {
    '/etc/mysql/my.cnf':
      ensure  => present,
      source  => 'puppet:///modules/mysql/my.cnf',
      require => File['/etc/mysql'],
  }

  exec{
    'set myconf permissions':
      command => 'sudo chmod 644 /etc/mysql/my.cnf',
      require => File['/etc/mysql/my.cnf'],
  }

  package {
    ['mysql-server-5.6', 'php5-mysql']:
      ensure  => present,
      require => Exec['install packages', 'set myconf permissions'],
  }

  service {
    'mysql':
      ensure  => running,
      require => Package['mysql-server-5.6']
  }

  exec {
    'set mysql root password':
      unless  => "mysqladmin -u${rootUsername} -p${rootPassword} status",
      command => "mysqladmin -u ${rootUsername} password ${rootPassword}",
      require => Service['mysql']
  }

  exec {
    'create database':
      unless  => "mysql -u${rootUsername} -p${rootPassword} ${databaseName}",
      command => "mysql -u${rootUsername} -p${rootPassword} -e \"create database ${databaseName};\"",
      require => Exec['set mysql root password']
  }
}
