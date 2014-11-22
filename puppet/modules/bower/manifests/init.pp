class bower($cwd = '/vagrant', $user = 'vagrant') {
  exec {
    'install bower globally':
      command  => 'sudo -H npm install -g bower',
      creates  => '/usr/bin/bower',
      require  => Package['nodejs'],
  }

  exec {
    'bower install':
      command => 'bower install --quiet --config.interactive=false',
      cwd     => $cwd,
      user    => $user,
      onlyif  => "ls ${cwd}/bower.json",
      require => Exec['install bower globally'],
  }
}
