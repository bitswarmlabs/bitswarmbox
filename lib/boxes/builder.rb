module Boxes
  # Class which drives the build process.
  class Builder
    include Boxes::Errors

    attr_accessor :name, :template, :scripts, :provider

    # Initialise a new build.
    #
    # @param env [Boxes::Environment] environment to operate in.
    # @param args [Hash]
    # @param template [String] the name of the template.
    # @param scripts [Array] scripts to include in the build.
    def initialize(env, args) # rubocop:disable Metrics/MethodLength
      @name = args[:name] || fail(MissingArgumentError,
                                  'The name must be specified.')
      @provider = args[:provider] || fail(MissingArgumentError,
                                          'The provider must be specified.')
      template = args[:template] || fail(MissingArgumentError,
                                         'The template must be specified.')
      scripts = args.fetch(:scripts, [])

      @template = Template.new(env, template)
      @scripts = scripts.collect do |c|
        env.available_scripts.include?(c) ? c : fail(ScriptNotFoundError)
      end
    end

    # Run the build.
    def run # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      # render the template
      rendered_template = template.render(name: name,
                                          provider: provider,
                                          scripts: scripts)

      # write the template to a file
      File.open(Boxes.config.working_dir + "#{build_name}.json", 'w') do |f|
        f.puts rendered_template
      end

      # execute the packer command
      FileUtils.chdir(Boxes.config.working_dir)
      cmd = "packer build #{build_name}.json"
      Subprocess.run(cmd) do |stdout, stderr, _thread|
        puts stdout unless stdout.nil?
        puts stderr unless stderr.nil?
      end
    end

    # Clean any temporary files used during building.
    def clean
      FileUtils.rm("#{build_name}.json")
    end

    private

    def build_name
      @build_name ||= "#{@name}-#{Time.now.strftime('%Y%m%d%H%M%S')}"
    end
  end
end
