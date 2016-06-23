class packer::aws::cloudinit {
  include '::packer::aws'

  $distro = $::operatingsystem ? {
    /(RedHat|CentOS|Fedora|Scientific|SL|SLC|Ascendos|CloudLinux|PSBM|OracleLinux|OVS|OEL|Amazon|XenServer)/ => 'redhat',
    'Debian' => 'debian',
    'Ubuntu' => 'ubuntu',
    'Archlinux' => 'archlinux',
    'Gentoo' => 'gentoo',
  }

  file { '/etc/cloud':
    ensure => directory,
  }

  file { '/etc/cloud/cloud.cfg':
    ensure  => file,
    content => template("packer/ec2/${distro}-cloud-cfg.erb")
  }
}
