require 'optparse'
require 'yaml'

module BitswarmBox
  class Command
    # Command handling for the box building functionality.
    class Build < Command
      self.summary = 'Build boxes'
      self.description = 'Builds boxes using templates and scripts.'

      def self.options
        [
            ['--name', 'The name for the build'],
            ['--description', 'Longer text description of the build'],
            ['--provider=[virtualbox|vmware|aws-ec2]',
             'The provider to build the box for'],
            ['--template', 'Template to build the box with'],
            ['--scripts', 'Scripts to apply to the box'],
            ['--app_creator', 'Your name to be used within build metadata, e.g. bitswarmlabs. (will be created as custom fact for Puppet)'],
            ['--app_project', 'Project identifier to be used within build metadata, e.g. puppetmaster. (will be created as custom fact for Puppet)'],
            ['--app_version', 'Semantic version identifier to be used within build metadata, e.g. 0.1.0. (will be created as custom fact for Puppet)'],
            ['--aws_access_key_id', 'For aws-ec2 provider, your API access key'],
            ['--aws_secret_access_key', 'For aws-ec2 provider, your API access secret'],
            ['--aws_region', 'For aws-ec2 provider, an acceptable region e.g. us-east-1'],
            ['--aws_source_ami', 'For aws-ec2 provider, the base AMI to build upon specific for a region'],
        ].concat(super)
      end

      def initialize(argv)
        @build = {}
        @build[:name] = argv.option('name')
        @build[:provider] = argv.option('provider')
        @build[:template] = argv.option('template')
        scripts = argv.option('scripts') || ''
        @build[:scripts] = scripts.split(',')
        @build[:app_creator] = argv.option('app_creator')
        @build[:app_project] = argv.option('app_project')
        @build[:app_version] = argv.option('app_version')
        @build[:aws_access_key_id] = argv.option('aws_access_key_id')
        @build[:aws_secret_access_key] = argv.option('aws_secret_access_key')
        super
      end

      def validate!
        super

        %w(name provider template).each do |key|
          help! "A #{key} is required!" if @build[key.to_sym].nil?
        end

        if @build[:provider].equal?('aws-ec2')
          %w(aws_access_key_id aws_secret_access_key aws_region aws_source_ami).each do |key|
            help! "For aws-ec2 provisioner, #{key} is required!" if @build[key.to_sym].nil?
          end
          @build[:provisioner] = 'ec2'
        else
          @build[:provisioner] = 'vagrant'
        end

        if @build[:app_creator].nil?

        end
      end

      def run
        env = BitswarmBox::Environment.new
        builder = BitswarmBox::Builder.new(env, @build)
        builder.run
        builder.clean
      rescue BitswarmBox::Errors::BuildRunError => e
        puts "[!] #{e}".red
        exit 1
      end
    end
  end
end
