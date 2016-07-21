module BitswarmBox
  class Command
    class Build < Command
      class Aws < Build
        self.summary = 'Build a Bitswarm AWS AMI'
        self.description = 'Builds an EC2 AMI for running the Bitswarm ecosystem using templates and scripts.'

        def self.options
          [
              ['--name=<box_name>', 'The AMI name (required)'],
              ['--description', 'The AMI description'],
              ['--provider=[amazon-ebs]', 'Packer provider model to utilize (defaults to amazon-ebs)'],
              ['--template=<path/to/template>', 'Relative path within templates/ to build the box with (required)'],
              ['--app_creator', 'app_creator metadata fact, for use with Puppet'],
              ['--app_project', 'app_project metadata fact, for use with Puppet. Ignored if --puppetserver flag is used'],
              ['--app_version', 'app_version metadata fact, for use with Puppet'],
              ['--aws_access_key', 'AWS API Access Key (defaults to ENV[AWS_ACCESS_KEY])'],
              ['--aws_secret_key', 'AWS API Secret Key (defaults to ENV[AWS_SECRET_KEY])'],
              ['--aws_region', 'AWS Region (defaults to us-west-1)'],
              ['--aws_source_ami', 'AMI upon which to work (must be available in aws_region)'],
              ['--aws_user_data', 'User data to send to AWS builder'],
              ['--puppet', 'Install basic Puppet client'],
              ['--puppetserver', 'Install Puppet Server and provision'],
              ['--foreman', 'Install Foreman and provision'],
              ['--docker', 'Install latest Docker'],
              ['--chef', 'Install basic Chef client'],
              ['--ansible', 'Install basic Ansible client'],
              ['--scripts', 'Extra scripts to apply to the box (comma delimited paths)'],
              ['--bootstrap', 'Execute bootstrap provisioning during build (Puppet apply etc)']
          ].concat(super)
        end

        def initialize(argv)
          @build = {}
          @build[:provisioner] = 'aws'
          @build[:packer_shell_exec_cmd] = "{{ .Vars }} sudo -E sh '{{ .Path }}'"

          @build[:name] = argv.option('name')
          @build[:description] = argv.option('description')
          @build[:provider] = argv.option('provider') || 'amazon-ebs'
          @build[:template] = argv.option('template')

          @build[:app_creator] = argv.option('app_creator')
          @build[:app_project] = argv.option('app_project')
          @build[:app_version] = argv.option('app_version')

          @build[:aws_access_key] = argv.option('aws_access_key') || ENV['AWS_ACCESS_KEY']
          @build[:aws_secret_key] = argv.option('aws_secret_key') || ENV['AWS_SECRET_KEY']
          @build[:aws_region] = argv.option('aws_region') || ENV['AWS_DEFAULT_REGION']
          @build[:aws_source_ami] = argv.option('aws_source_ami')
          @build[:aws_user_data] = argv.option('aws_user_data')

          @build[:puppet] = argv.flag?('puppet')
          @build[:puppetserver] = argv.flag?('puppetserver')
          @build[:foreman] = argv.flag?('foreman')
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

            if @build[:foreman]
              if @build[:foreman_admin_username].nil? || @build[:foreman_admin_password].nil?
                help! "Must provide --foreman-admin-username and --foreman-admin-password"
              end
            end
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
end
