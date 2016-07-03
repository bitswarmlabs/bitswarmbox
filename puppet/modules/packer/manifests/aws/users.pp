class packer::aws::users {
  include '::packer::aws'
  $service_acct = $::packer::aws::local_service_acct_user

  include ohmyzsh

  if and str2bool($::packer::aws::manage_users) {
    user { $service_acct:
      ensure     => present,
      shell      => $::ohmyzsh::config::path,
    }
  }

  class { 'ohmyzsh::config': theme_hostname_slug => '%M' }

  # for multiple users in one shot and set their shell to zsh
  ohmyzsh::install { 'root': set_sh => true, disable_auto_update => true }
  ohmyzsh::install { $service_acct: set_sh => true, disable_update_prompt => true }
  ohmyzsh::plugins { ['root', $service_acct]: }
  ohmyzsh::theme { ['root', $service_acct]: }
}
