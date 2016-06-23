module BitswarmBox
  # Stores the configuration for BitswarmBox.
  class Config
    # The default settings for the configuration.
    DEFAULTS = {
      environment_vars: [
        { 'PACKER_CACHE_DIR' => (
            Pathname.new(ENV['BOXES_HOME_DIR'] || '~/.bitswarmbox'
                        ).expand_path + 'packer_cache')
        },
        { 'AWS_ACCESS_KEY_ID' => ENV['AWS_ACCESS_KEY_ID'] },
        { 'AWS_SECRET_ACCESS_KEY' => ENV['AWS_SECRET_ACCESS_KEY'] },
        { 'AWS_DEFAULT_REGION' => ENV['AWS_DEFAULT_REGION'] },
      ],
      template_paths: [
        # the gem install directory
        File.expand_path('../../../templates', __FILE__)
      ],
      script_paths: [
        # the gem install directory
        File.expand_path('../../../scripts', __FILE__)
      ],
      puppet_lib_paths: [
        # the gem install directory
        File.expand_path('../../../puppet', __FILE__)
      ],
      ssh_key_paths: [
        # the gem install directory
        File.expand_path('../../../keys', __FILE__)
      ]
    }

    # The directory which bitswarmbox works out of.
    def home_dir
      @home_dir ||= Pathname.new(
        ENV['BOXES_HOME_DIR'] || '~/.bitswarmbox').expand_path
    end

    # The directory inside the `home_dir` which bitswarmbox runs builds inside of.
    def working_dir
      @working_dir ||= Pathname.new(
        ENV['BOXES_WORKING_DIR'] || home_dir + 'tmp').expand_path
    end

    # Paths known to bitswarmbox for discovering templates.
    attr_accessor :template_paths

    # Paths known to bitswarmbox for discovering scripts.
    attr_accessor :script_paths

    attr_accessor :puppet_lib_paths, :ssh_key_paths

    # A Hash of environment variables BitswarmBox sets in the run environment.
    attr_accessor :environment_vars

    def initialize
      configure_with(DEFAULTS)

      return unless user_settings_file.exist?

      user_settings = YAML.load_file(user_settings_file)
      configure_with(user_settings)
    end

    private

    def user_settings_file
      home_dir + 'config.yml'
    end

    def configure_with(opts = {}) # rubocop:disable Metrics/MethodLength
      opts.each do |k, v|
        next unless respond_to?("#{k}=")

        if v.class == Array
          v.each do |e|
            set = Set.new(send("#{k}".to_sym))
            set << e
            send("#{k}=".to_sym, set.to_a)
          end
        else
          send("#{k}=".to_sym, v)
        end
      end
    end
  end
end
