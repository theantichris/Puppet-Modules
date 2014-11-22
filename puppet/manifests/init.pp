Exec { path => [ "/bin/", "/usr/bin/", "/usr/local/bin/" ] }

exec {
  'install packages':
    command => 'sudo apt-get update && sudo apt-get install -y git python-software-properties g++',
    creates => ['/usr/bin/git', '/usr/bin/g++'],
}

host {
  'puppet.192.168.56.107.xip.io':
    ip => '127.0.1.1'
}

# include <comma separated list of desired modules>
include mongodb