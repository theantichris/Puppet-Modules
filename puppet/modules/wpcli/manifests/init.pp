class wpcli {
  exec {
    'download-wp-cli':
    command => 'curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar',
    cwd => '/vagrant',
    unless => 'ls /usr/local/bin/wp',
  }

  exec {
    'make-wp-cli-executable':
    command => 'chmod +x wp-cli.phar',
    cwd => '/vagrant',
    require => Exec['download-wp-cli'],
    unless => 'ls /usr/local/bin/wp',
  }

  exec {
    'move-wp-cli':
    command => 'sudo mv wp-cli.phar /usr/local/bin/wp',
    cwd => '/vagrant',
    require => Exec['make-wp-cli-executable'],
    unless => 'ls /usr/local/bin/wp',
  }
}