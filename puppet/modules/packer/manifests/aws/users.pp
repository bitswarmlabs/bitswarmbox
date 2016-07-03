class packer::aws::users(
  $helloworld = undef,
) {
  include '::packer::aws'

  $service_acct = $::packer::aws::local_service_acct_user

  if $helloworld {
    notify { "# Hello?: ${helloworld}": }
  }

  class { 'ohmyzsh::config': theme_hostname_slug => '%M' }

  if str2bool($::packer::aws::manage_users) {
    # don't need to do much for this user as its managed typically by cloud-init
    user { $service_acct:
      ensure     => present,
      shell      => $::ohmyzsh::config::path,
      require    => Package[$::ohmyzsh::config::zsh_package_name],
    }
  }

  # for multiple users in one shot and set their shell to zsh
  ohmyzsh::install { 'root': set_sh => true, disable_auto_update => true }
  ohmyzsh::install { $service_acct: set_sh => true, disable_update_prompt => true }
  ohmyzsh::plugins { ['root', $service_acct]: }
  ohmyzsh::theme { ['root', $service_acct]: }
}
