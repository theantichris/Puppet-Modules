class gruntjs {
  exec {
    'npm install -g grunt-cli':
    unless => 'ls /usr/bin/grunt',
    require => Package['nodejs'],
  }
}