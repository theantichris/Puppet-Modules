class wordpress {
  exec {
    'download-wordpress':
    command => 'wget http://wordpress.org/latest.tar.gz',
    unless => 'ls /var/www/index.php',
    cwd => '/vagrant',
    require => File['/var/www'],
  }

  exec {
    'unzip-wordpress':
    command => 'tar -xzvf latest.tar.gz',
    unless => 'ls /var/www/index.php',
    cwd => '/vagrant',
    require => Exec['download-wordpress'],
    notify => Exec['delete-wordpress-archive'],
  }

  file {
    '/vagrant/wordpress/wp-config.php':
    ensure => present,
    source => 'puppet:///modules/wordpress/wp-config.php',
    require => Exec['unzip-wordpress'],
  }

  # Copy the WordPress files to the web root.
  exec {
    'copy-wordpress':
    command => 'cp -r ./wordpress/* /var/www',
    cwd => '/vagrant',
    require => File['/vagrant/wordpress/wp-config.php'],
    notify => Exec['delete-wordpress-folder'],
  }

  exec {
    'delete-wordpress-archive':
    command => 'rm latest.tar.gz',
    cwd => '/vagrant',
    refreshonly => true,
  }

  exec {
    'delete-wordpress-folder':
    command => 'rm -rf ./wordpress',
    cwd => '/vagrant',
    refreshonly => true,
  }
}