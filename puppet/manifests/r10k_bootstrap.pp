class r10k_bootstrap(
  $project = "${::app_project}",
) {
  notify { "## Bootstrapping r10k and local Puppet module library": }

  package { 'r10k':
    provider => puppet_gem,
    ensure   => installed
  }
  ->
  file { '/usr/bin/r10k':
    ensure  => link,
    target  => '/opt/puppetlabs/puppet/bin/r10k',
    force   => true,
  }

  if $project == 'puppetmaster' {
    $data_root = '/etc/puppetlabs/code'
  }
  else {
    $data_root = '/opt/puppetlabs/puppet'
  }

  file { "${data_root}/Puppetfile":
    ensure => file,
    source => '/tmp/Puppetfile',
  }
  ~>
  exec { 'r10k puppetfile install -v':
    logoutput   => true,
    refreshonly => true,
    cwd         => $data_root,
    path        => '/usr/bin:/bin',
  }
}

include 'r10k_bootstrap'
