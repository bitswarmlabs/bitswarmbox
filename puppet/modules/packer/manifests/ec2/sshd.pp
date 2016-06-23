class packer::ec2::sshd {

  class { 'ssh::server':
    storeconfigs_enabled => false,
    options => {
      'PermitRootLogin'      => 'without-password',
      'GSSAPIAuthentication' => 'no',
    },
  }
}
