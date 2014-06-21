class nodejs{
  exec {
    'add-nodejs-repo':
    command => 'sudo add-apt-repository ppa:chris-lea/node.js',
    unless => 'ls /etc/apt/sources.list.d/chris-lea-node_js-precise.list',
    notify => Exec['update-for-repo'],
    require => Package['python-software-properties'],
  }

  package {
    'nodejs':
    ensure => present,
    require => Exec['add-nodejs-repo', 'update-for-repo'],
  }
}