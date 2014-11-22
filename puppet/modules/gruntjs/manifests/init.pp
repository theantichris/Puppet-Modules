class gruntjs($cwd = '/vagrant', $user = 'vagrant'){
  exec {
    'install grunt-cli globally':
      command  => 'sudo -H npm install -g grunt-cli',
      creates  => '/usr/bin/grunt',
      require  => Package['nodejs'],
  }

  exec {
    'run grunt':
      command => 'grunt',
      cwd     => $cwd,
      user    => $user,
      onlyif  => "ls ${cwd}/Gruntfile.js",
      require => Exec['install grunt-cli globally', 'install node packages'],
  }
}
