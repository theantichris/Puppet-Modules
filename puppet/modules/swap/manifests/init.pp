class swap($swapfile = '/swapfile', $size = '1G'){
  exec {
    'make swapfile':
      command => "sudo fallocate -l ${size} ${swapfile}",
      creates => $swapfile,
  }

  exec {
    'make swap':
      command     => "sudo mkswap ${swapfile} && sudo swapon ${swapfile}",
      unless      => "sudo swapon -s | grep ${swapfile}",
      require     => Exec['make swapfile'],
      notify      => Exec['update fstab'],
  }

  exec {
    'update fstab':
      command     => "sudo echo '${swapfile}  none  swap  sw  0 0' >> /etc/fstab",
      refreshonly => true,
  }
}