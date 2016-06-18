require 'set'
require 'fileutils'
require 'pathname'
require 'yaml'
require 'open3'
require 'erb'

require 'claide'
require 'colored'

require 'bitswarmbox/version'
require 'bitswarmbox/errors'
require 'bitswarmbox/config'
require 'bitswarmbox/subprocess'
require 'bitswarmbox/environment'
require 'bitswarmbox/template'
require 'bitswarmbox/builder'
require 'bitswarmbox/command'

# Toolkit for building Vagrantboxes, VM and cloud images.
module BitswarmBox
  class << self
    attr_reader :config

    def config
      @config ||= Config.new
    end
  end
end
