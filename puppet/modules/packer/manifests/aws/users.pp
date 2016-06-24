class packer::aws::users {
  include '::packer::aws'
  $service_acct = $::packer::aws::local_service_acct_user

  if $service_acct != 'ubuntu' {
    user { $service_acct:
      ensure     => present,
      home       => "/home/${service_acct}",
      managehome => true,
    }
    ->
    sudo::sudoers { $service_acct:
      ensure   => 'present',
      users    => [$service_acct],
      tags     => ['NOPASSWD'],
      defaults => [ 'env_keep += "SSH_AUTH_SOCK"' ]
    }
  }

  # for multiple users in one shot and set their shell to zsh
  ohmyzsh::install { ['root', $service_acct]: set_sh => true, disable_auto_update => true }
  ohmyzsh::theme { ['root', $service_acct]: theme => 'dpoggi' }
}
