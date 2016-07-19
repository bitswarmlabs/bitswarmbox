module BitswarmBox
  class Command
    class Build < Command
      class Vagrant < Build
        self.summary = 'Build a Bitswarm Vagrant box'
        self.description = 'Builds a vagrant box for testing Bitswarm ecosystem using templates and scripts.'

        def self.options
          [
              ['--name=<box_name>', 'The name for the build and resulting box (required)'],
              ['--provider=[virtualbox|vmware]', 'The host VM provider to build the box for (required)'],
              ['--template=<path/to/template>', 'Relative path within templates/ to build the box with (required)'],
              ['--app_creator', 'app_creator metadata fact, for use with Puppet'],
              ['--app_project', 'app_project metadata fact, for use with Puppet'],
              ['--app_version', 'app_version metadata fact, for use with Puppet'],
              ['--puppet', 'Install basic Puppet client'],
              ['--puppetserver', 'Install Puppet Server and provision'],
              ['--foreman', 'Install Foreman and provision'],
              ['--foreman-admin-username', 'If Foreman, the admin username (required if --foreman enabled)'],
              ['--foreman-admin-password', 'If Foreman, the password (required if --foreman enabled)'],
              ['--docker', 'Install latest Docker'],
              ['--chef', 'Install basic Chef client'],
              ['--ansible', 'Install basic Ansible client'],
              ['--scripts', 'Extra scripts to apply to the box (comma delimited paths)'],
              ['--bootstrap', 'Execute bootstrap provisioning during build (Puppet apply etc)']
          ].concat(super)
        end

        def initialize(argv)
          @build = {}
          @build[:provisioner] = 'vagrant'
          @build[:packer_shell_exec_cmd] = "echo 'vagrant' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"

          @build[:name] = argv.option('name')
          @build[:provider] = argv.option('provider')
          @build[:template] = argv.option('template')

          @build[:app_creator] = argv.option('app_creator')
          @build[:app_project] = argv.option('app_project')
          @build[:app_version] = argv.option('app_version')

          @build[:puppet] = argv.flag?('puppet')
          @build[:puppetserver] = argv.flag?('puppetserver')
          @build[:foreman] = argv.flag?('foreman')
          @build[:foreman_admin_username] = argv.option('foreman-admin-username')
          @build[:foreman_admin_password] = argv.option('foreman-admin-password')

          @build[:docker] = argv.flag?('docker')
          @build[:chef] = argv.flag?('chef')
          @build[:ansible] = argv.flag?('ansible')

          scripts = argv.option('scripts') || ''
          @build[:scripts] = scripts.split(',')

          @build[:bootstrap] = argv.flag?('bootstrap')

          super
        end

        def validate!
          super

          %w(name provider template).each do |key|
            help! "A #{key} is required!" if @build[key.to_sym].nil?
          end

          if !@build[:app_project]
            if @build[:puppetserver]
              @build[:app_project] = 'puppetmaster'
            elsif @build[:foreman]
              @build[:app_project] = 'foreman'
            else
              help! "Cannot be both Puppetserver and Foreman, choose one"
            end
          end

        end

        def run
          env = BitswarmBox::Environment.new
          builder = BitswarmBox::Builder.new(env, @build)
          builder.run
          builder.finalize
          builder.clean
        rescue BitswarmBox::Errors::BuildRunError => e
          puts "[!] #{e}".red
          exit 1
        end
      end
    end
  end
end
