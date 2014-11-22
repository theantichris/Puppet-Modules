class ruby($cwd = '/vagrant', $user = 'vagrant'){
  package {
    'ruby1.9.3':
      ensure  => present,
      require => Exec['install packages'],
  }

  package {
    'bundler':
      ensure   => installed,
      provider => gem,
      require  => Package['ruby1.9.3'],
  }

  exec {
    'bundle install':
      command => 'bundle install',
      cwd     => $cwd,
      user    => $user,
      onlyif  => "ls ${cwd}/Gemfile",
      require => Package['bundler'],
  }
}