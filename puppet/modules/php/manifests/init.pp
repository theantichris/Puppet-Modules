class php($webRoot = '/vagrant/web') {
  package {
    ['php5-fpm', 'php5-cli', 'php5-mysql', 'php5-curl', 'php5-mcrypt', 'php5-dev']:
      ensure  => present,
      require => Exec['update-package-list'],
  }

  service {
    'php5-fpm':
      ensure  => running,
      require => Package['php5-fpm'],
  }

  exec {
    'enable-mcrypt':
      command => 'sudo php5enmod mcrypt',
      unless  => 'php -m | grep "mcrypt"',
      require => Package['php5-mcrypt'],
      notify  => Service['php5-fpm']
  }
}
