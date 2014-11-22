class wpcli($cwd = '/vagrant'){
  exec {
    'download wpcli':
      command  => 'curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar',
      cwd      => $cwd,
      creates  => '/usr/local/bin/wp',
      notify   => Exec['make wpcli executable'],
  }

  exec {
    'make wpcli executable':
      command     => 'sudo chmod +x wp-cli.phar',
      cwd         => $cwd,
      refreshonly => true,
      notify      => Exec['move wpcli'],
  }

  exec {
    'move wpcli':
      command     => 'sudo mv wp-cli.phar /usr/local/bin/wp',
      cwd         => $cwd,
      refreshonly => true,
  }
}