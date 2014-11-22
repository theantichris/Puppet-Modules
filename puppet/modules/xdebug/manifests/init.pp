class xdebug($xdebugVersion = 'xdebug-2.2.5', $homeDirectory = '/home/vagrant', $installedFile = '/usr/lib/php5/20121212/xdebug.so'){
  exec {
    'download xdebug':
      command  => "curl -O http://xdebug.org/files/${xdebugVersion}.tgz",
      creates  => $installedFile,
      cwd      => $homeDirectory,
      require  => Package['php5-fpm', 'php5-dev'],
      notify   => Exec['unpack xdebug'],
  }

  exec {
    'unpack xdebug':
      command     => "tar -xvzf ${xdebugVersion}.tgz",
      cwd         => $homeDirectory,
      refreshonly => true,
      notify      => Exec['phpize xdebug'],
  }

  exec {
    'phpize xdebug':
      command     => 'phpize5',
      cwd         => "${homeDirectory}/${xdebugVersion}",
      refreshonly => true,
      notify      => Exec['configure xdebug'],
  }

  exec {
    'configure xdebug':
      command     => 'sudo ./configure',
      cwd         => "${homeDirectory}/${xdebugVersion}",
      refreshonly => true,
      notify      => Exec['make xdebug'],
  }

  exec {
    'make xdebug':
      command     => 'sudo make',
      cwd         => "${homeDirectory}/${xdebugVersion}",
      refreshonly => true,
      notify      => Exec['copy xdebug'],
  }

  exec {
    'copy xdebug':
      command     => "sudo cp modules/xdebug.so ${installedFile}",
      cwd         => "${homeDirectory}/${xdebugVersion}",
      refreshonly => true,
      notify      => Exec['update php.ini']
  }

  exec {
    'update php.ini':
      command     => "sudo echo 'zend_extension = ${installedFile}' >> /etc/php5/fpm/php.ini",
      refreshonly => true,
      notify      => [Service['php5-fpm'], Exec['delete xdebug download']],
  }

  exec {
    'delete xdebug download':
      command     => "sudo rm -rf ${homeDirectory}/${xdebugVersion}* && sudo rm ${homeDirectory}/package.xml",
      refreshonly => true,
  }
}