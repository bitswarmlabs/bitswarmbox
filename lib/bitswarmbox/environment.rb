require "rsync"

module BitswarmBox
  # For creating and managing the environment which bitswarmbox uses.
  class Environment
    def initialize
      FileUtils.mkdir_p(BitswarmBox.config.working_dir)

      sync_templates
      sync_scripts
      sync_puppet
      sync_ssh_keys
    end

    def available_templates
      t = Dir.glob("#{BitswarmBox.config.working_dir}/templates/*/**")
      a = t.collect { |c| c.include?('preseed.cfg') ? next : c }.compact

      a.collect do |c|
        c = c.gsub(BitswarmBox.config.working_dir.to_s + '/templates/', '')
        c.gsub('.erb', '')
      end
    end

    def hidden_templates
      t = Dir.glob("#{BitswarmBox.config.working_dir}/templates/*/**")
      a = t.collect { |c| c.include?('preseed.cfg') ? c : next }.compact

      a.collect do |c|
        c.gsub(BitswarmBox.config.working_dir.to_s + '/templates/', '')
      end
    end

    def available_scripts
      t = Dir.glob("#{BitswarmBox.config.working_dir}/scripts/*")
      a = t.collect { |c| c.include?('purge.sh') ? next : c }.compact

      a.collect do |c|
        c.gsub(BitswarmBox.config.working_dir.to_s + '/scripts/', '')
      end
    end

    def hidden_scripts
      t = Dir.glob("#{BitswarmBox.config.working_dir}/scripts/*")
      a = t.collect { |c| c.include?('purge.sh') ? c : next }.compact

      a.collect do |c|
        c.gsub(BitswarmBox.config.working_dir.to_s + '/scripts/', '')
      end
    end

    private

    def copy_templates
      templates_dir = BitswarmBox.config.working_dir + 'templates'

      FileUtils.mkdir_p(templates_dir)

      BitswarmBox.config.template_paths.each do |template_path|
        Dir.glob("#{template_path}/*").each do |src_template|
          FileUtils.cp_r(src_template, templates_dir)
        end
      end
    end

    def sync_templates
      BitswarmBox.config.template_paths.each do |template_path|
        Rsync.run(template_path, BitswarmBox.config.working_dir, ['-av', '--delete']) do |result|
          if result.success?
            result.changes.each do |change|
              puts "#{change.filename} (#{change.summary})"
            end
          else
            fail BuildRunError, result.error
          end
        end
      end
    end

    def copy_scripts
      scripts_dir = BitswarmBox.config.working_dir + 'scripts'

      FileUtils.mkdir_p(BitswarmBox.config.working_dir + 'scripts')

      BitswarmBox.config.script_paths.each do |script_path|
        Dir.glob("#{script_path}/*").each do |src_script|
          FileUtils.cp_r(src_script, scripts_dir)
        end
      end
    end

    def sync_scripts
      BitswarmBox.config.script_paths.each do |script_path|
        Rsync.run(script_path, BitswarmBox.config.working_dir, ['-av', '--delete']) do |result|
          if result.success?
            result.changes.each do |change|
              puts "#{change.filename} (#{change.summary})"
            end
          else
            fail BuildRunError, result.error
          end
        end
      end
    end

    def copy_puppet_lib
      puppet_lib_dir = BitswarmBox.config.working_dir + 'puppet'

      FileUtils.mkdir_p(puppet_lib_dir)

      BitswarmBox.config.puppet_lib_paths.each do |puppet_lib_path|
        Dir.glob("#{puppet_lib_path}/*").each do |src_puppet_lib|
          FileUtils.cp_r(src_puppet_lib, puppet_lib_dir)
        end
      end
    end

    def sync_puppet
      BitswarmBox.config.puppet_lib_paths.each do |puppet_path|
        Rsync.run(puppet_path, BitswarmBox.config.working_dir, ['-av', '--delete']) do |result|
          if result.success?
            result.changes.each do |change|
              puts "#{change.filename} (#{change.summary})"
            end
          else
            fail BuildRunError, result.error
          end
        end
      end
    end

    def copy_ssh_keys
      key_dir = BitswarmBox.config.working_dir + 'keys'

      FileUtils.mkdir_p(BitswarmBox.config.working_dir + 'keys')

      BitswarmBox.config.ssh_key_paths.each do |key_path|
        Dir.glob("#{key_path}/*").each do |src_keyfile|
          FileUtils.cp_r(src_keyfile, key_dir)
        end
      end
    end

    public

    def sync_ssh_keys(reverse = false)
      key_dir = BitswarmBox.config.working_dir + 'puppet'

      FileUtils.mkdir_p(key_dir)

      BitswarmBox.config.ssh_key_paths.each do |key_path|
        if reverse
          Rsync.run(key_dir, File.expand_path("#{key_path}/.."), ['-av', '--delete']) do |result|
            if result.success?
              result.changes.each do |change|
                puts "#{change.filename} (#{change.summary})"
              end
            else
              fail BuildRunError, result.error
            end
          end
        else
          Rsync.run(key_path, BitswarmBox.config.working_dir, ['-av', '--delete']) do |result|
            if result.success?
              result.changes.each do |change|
                puts "#{change.filename} (#{change.summary})"
              end
            else
              fail BuildRunError, result.error
            end
          end
        end
      end
    end
  end
end
