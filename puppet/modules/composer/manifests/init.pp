class composer($cwd = '/vagrant', $user = 'vagrant') {
  exec {
    'download composer':
      command => 'curl -sS https://getcomposer.org/installer | php',
      creates => '/usr/local/bin/composer',
      require => Package['php5-cli'],
  }

  exec {
    'move composer':
      command     => 'mv composer.phar /usr/local/bin/composer',
      require     => Exec['download composer'],
      creates     => '/usr/local/bin/composer',
  }

  exec {
    'run composer update':
      command => 'composer update --quiet --no-interaction',
      cwd     => $cwd,
      user    => $user,
      onlyif  => "ls ${cwd}/composer.json",
      require => Exec['move composer'],
  }
}
