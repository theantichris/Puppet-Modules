class bower($cwd = '/vagrant') {
  exec {
    'install-bower':
      command => 'sudo npm install -g bower',
      unless  => 'ls /usr/bin/bower',
      require => Package['nodejs'],
  }

  exec {
    'bower-install':
      command => 'bower install --quiet --config.interactive=false',
      cwd     => "${cwd}",
      user    => 'vagrant',
      onlyif  => "ls ${cwd}/bower.json",
      require => Exec['install-bower'],
  }
}
