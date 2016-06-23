class packer::clock(
  $timezone = 'America/New_York'
) {
  include '::ntp'

  class { '::timezone':
    timezone => $timezone,
  }

}