class bower {
  exec {
    'install-bower':
    command => 'sudo npm install -g bower',
    unless => 'ls /usr/bin/bower',
    require => Package['nodejs'],
  }
}