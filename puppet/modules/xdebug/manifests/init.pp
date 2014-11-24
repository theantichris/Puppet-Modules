class xdebug($xdebugVersion = 'xdebug-2.2.5', $homeDirectory = '/home/vagrant', $installedFile = '/usr/lib/php5/20121212/xdebug.so'){
  exec {
    'download xdebug':
      command  => "curl -O http://xdebug.org/files/${xdebugVersion}.tgz",
      creates  => $installedFile,
      cwd      => $homeDirectory,
      require  => Package['php5-fpm', 'php5-dev'],
  }

  exec {
    'unpack xdebug':
      command => "tar -xvzf ${xdebugVersion}.tgz",
      creates => $installedFile,
      cwd     => $homeDirectory,
      require => Exec['download xdebug'],
  }

  exec {
    'phpize xdebug':
      command => 'phpize5',
      creates => $installedFile,
      cwd     => "${homeDirectory}/${xdebugVersion}",
      require => Exec['unpack xdebug'],
  }

  exec {
    'configure xdebug':
      command => 'sudo ./configure',
      creates => $installedFile,
      cwd     => "${homeDirectory}/${xdebugVersion}",
      require => Exec['phpize xdebug'],
  }

  exec {
    'make xdebug':
      command => 'sudo make',
      creates => $installedFile,
      cwd     => "${homeDirectory}/${xdebugVersion}",
      require => Exec['configure xdebug'],
  }

  exec {
    'copy xdebug':
      command => "sudo cp modules/xdebug.so ${installedFile}",
      creates => $installedFile,
      cwd     => "${homeDirectory}/${xdebugVersion}",
      require => Exec['make xdebug'],
      notify  => Exec['update php.ini'],
  }

  exec {
    'update php.ini':
      command     => "sudo echo 'zend_extension = ${installedFile}' >> /etc/php5/fpm/php.ini",
      require     => Exec['copy xdebug'],
      refreshonly => true,
      notify      => Exec['delete xdebug download'],
  }

  exec {
    'delete xdebug download':
      command     => "sudo rm -rf ${homeDirectory}/${xdebugVersion}* && sudo rm ${homeDirectory}/package.xml",
      refreshonly => true,
  }
}