module Guesser
  module Configuration
    def parse_args(argv)
      return defaults if argv.empty?

      begin
        options = Slop.parse(argv, strict: true, help: true,
                             banner: 'Welcome to the Guesser game. Here is the list of available options:') do
          on '-o', '--points', 'Points to win (integer, greater than 0).', as: Integer, argument: true
          on '-i', '--limit', 'Guessed number limit (integer, greater than 0).', as: Integer, argument: true
          on '-p', '--players', 'How many players will participate (integer, greater than 0).', as: Integer, argument: true
        end.to_hash

        normalize! options
      rescue Slop::Error => e
        puts e.message
        puts "[WARNING] Using default options. Provide --help to view info about available options."
        defaults
      end
    end

    def load_defaults!
      Guesser.const_set(:CONFIG, {})
      config_file = File.expand_path('../../../config.yml', __FILE__)
      begin
        yaml_conf = YAML.load(File.open(config_file))
        yaml_conf.each do |k, v|
          value = Integer(v)
          raise RangeError, "[ERROR] The provided value #{value} for the #{k} setting is incorrect." if value < 1
          CONFIG[k.to_sym] = value
        end
      rescue Errno::ENOENT
        abort "[ERROR] config.yml file does not exist! This means that the default options could not be loaded. Please create refer to the documentation for more information."
      rescue NoMethodError
        abort "[ERROR] config.yml file appears to be empty! This means that the default options could not be loaded. Please create refer to the documentation for more information."
      rescue RangeError => e
        abort e.message
      end
    end

    private

    def defaults
      begin
        opts = {}
        [:points, :limit, :players].each do |k|
          opts.merge!(Hash[k, CONFIG.fetch(k) do
                             raise KeyError, "[ERROR] #{k} setting is not provided in the config.yml file!"
                           end
                     ])
        end
        opts
      rescue KeyError => e
        abort e.message
      end
    end

    def normalize!(opts)
      opts.reject! {|k, v| v.to_i < 1}.merge!(defaults) {|k, v1, v2| v1}
    end
  end
end