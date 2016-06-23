class packer::ec2::users {
  include '::packer::ec2'
  $service_acct = $::packer::ec2::local_service_acct_user

  if $service_acct != 'ubuntu' {
    user { $service_acct:
      ensure     => present,
      home       => "/home/${service_acct}",
      managehome => true,
    }

    sudo::sudoers { 'sysops':
      ensure   => 'present',
      users    => [$service_acct],
      runas    => ['root'],
      cmnds    => ['ALL'],
      tags     => ['NOPASSWD'],
      defaults => [ 'env_keep += "SSH_AUTH_SOCK"' ]
    }
  }

  # for multiple users in one shot and set their shell to zsh
  ohmyzsh::install { ['root', $service_acct]: set_sh => true, disable_auto_update => true }
  ohmyzsh::theme { ['root', $service_acct]: theme => 'dpoggi' }
}
