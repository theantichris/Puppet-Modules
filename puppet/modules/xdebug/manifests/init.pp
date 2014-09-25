class xdebug($package = 'xdebug-2.2.5', $homeDirectory = '/home/vagrant', $installedFile = '/usr/lib/php5/20121212/xdebug.so'){
  exec {
    'download-xdebug':
      command => "curl -O http://xdebug.org/files/${package}.tgz",
      unless  => "ls ${installedFile}",
      cwd     => $homeDirectory,
      require => Package['php5-fpm', 'php5-dev'],
  }

  exec {
    'unpack-xdebug':
      command => "tar -xvzf ${package}.tgz",
      unless  => "ls ${installedFile}",
      cwd     => $homeDirectory,
      require => Exec['download-xdebug'],
  }

  exec {
    'phpize-xdebug':
      command => 'phpize5',
      unless  => "ls ${installedFile}",
      cwd     => "${homeDirectory}/${package}",
      require => Exec['unpack-xdebug'],
  }

  exec {
    'configure-xdebug':
      command => 'sudo ./configure',
      unless  => "ls ${installedFile}",
      cwd     => "${homeDirectory}/${package}",
      require => Exec['phpize-xdebug'],
  }

  exec {
    'make-xdebug':
      command => 'sudo make',
      unless  => "ls ${installedFile}",
      cwd     => "${homeDirectory}/${package}",
      require => Exec['configure-xdebug'],
  }

  exec {
    'copy-xdebug':
      command => 'sudo cp modules/xdebug.so /usr/lib/php5/20121212',
      unless  => "ls ${installedFile}",
      cwd     => "${homeDirectory}/${package}",
      require => Exec['make-xdebug'],
  }

  exec {
    'updated-phpini':
      command => 'sudo echo "zend_extension = /usr/lib/php5/20121212/xdebug.so" >> /etc/php5/fpm/php.ini',
      unless  => "grep -l 'xdebug.so' /etc/php5/fpm/php.ini",
      require => Exec['copy-xdebug'],
      notify  => Service['php5-fpm'],
  }
}