module BitswarmBox
  # Class which encapsulates the command line handling.
  class Command < CLAide::Command
    require 'bitswarmbox/command/build'
    require 'bitswarmbox/command/env'

    self.abstract_command = true
    self.command = 'bitswarmbox'
    self.version = VERSION
    self.description = 'Toolkit for building Vagrantboxes, VM and cloud images.'
  end
end
