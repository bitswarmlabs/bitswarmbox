class packer::aws::users {
  include '::packer::aws'
  $service_acct = $::packer::aws::local_service_acct_user

  if $service_acct != 'ubuntu' and str2bool($::packer::aws::manage_users) {
    user { $service_acct:
      ensure     => present,
      home       => "/home/${service_acct}",
      managehome => true,
    }
    # ->
    # sudo::sudoers { $service_acct:
    #   ensure   => 'present',
    #   users    => [$service_acct],
    #   tags     => ['NOPASSWD'],
    # }
  }

  class { 'ohmyzsh::config': theme_hostname_slug => '%M' }

  # for multiple users in one shot and set their shell to zsh
  ohmyzsh::install { 'root': set_sh => true, disable_auto_update => true }
  ohmyzsh::install { $service_acct: set_sh => true, disable_update_prompt => true }
  ohmyzsh::plugins { ['root', $service_acct]: }
  ohmyzsh::theme { ['root', $service_acct]: }
}
