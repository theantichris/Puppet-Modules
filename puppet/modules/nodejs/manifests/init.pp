class nodejs($cwd = '/vagrant', $user = 'vagrant'){
  exec {
    'add nodejs repo':
      command  => 'sudo add-apt-repository ppa:chris-lea/node.js && sudo apt-get update',
      creates  => '/etc/apt/sources.list.d/chris-lea-node_js-trusty.list',
      require  => Exec['install packages'],
  }

  package {
    'nodejs':
      ensure  => present,
      require => Exec['add nodejs repo'],
  }

  exec {
    'install node packages':
      command => 'npm install --no-bin-links --silent',
      cwd     => $cwd,
      user    => $user,
      onlyif  => "ls ${cwd}/package.json",
      require => Package['nodejs'],
  }
}