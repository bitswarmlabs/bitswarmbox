module BitswarmBox
  class Command
    # Command handling for the box building functionality.
    class Build < Command
      self.abstract_command = true

      self.summary = 'Build Bitswarm\'s boxes'
      self.description = 'Builds boxes for Bitswarm ecosystem using templates and scripts.'

      # def self.options
      #   [
      #       ['--name', 'The name for the build'],
      #       ['--template', 'Template to build the box with'],
      #   ].concat(super)
      # end

      # def initialize(argv)
      #   @build = {}
      #   @build[:name] = argv.option('name')
      #   @build[:template] = argv.option('template')
      #   scripts = argv.option('scripts') || ''
      #   @build[:scripts] = scripts.split(',')
      #
      #   super
      # end

      def validate!
        super
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
