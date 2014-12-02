require 'pry'
require 'yaml'
require 'slop'
require 'guesser/game'
require 'guesser/player'
require 'guesser/game_options'
require 'guesser/utils/file_manager'
require 'guesser/utils/hash'

module Guesser
  include Guesser::FileManager

  AVAILABLE_OPTIONS = [:points, :limit, :players]

  class << self
    def load_defaults!
      const_set(:CONFIG, {})
      config_file = File.expand_path('../../config.yml', __FILE__)
      begin
        yaml_conf = YAML.load_file(config_file).symbolize_keys

        AVAILABLE_OPTIONS.each do |k|
          value = yaml_conf.fetch(k) do
            raise KeyError, "[ERROR] #{k} setting is not provided in the config.yml file!"
          end
          value = Integer(value)
          raise RangeError, "[ERROR] The provided value #{value} for the #{k} setting is incorrect." if value < 1
          CONFIG[k] = value
        end
      rescue Errno::ENOENT
        abort "[ERROR] config.yml file does not exist! This means that the default options could not be loaded. Please create refer to the documentation for more information."
      rescue NoMethodError
        abort "[ERROR] config.yml file appears to be empty! This means that the default options could not be loaded. Please create refer to the documentation for more information."
      rescue RangeError => e
        abort e.message
      rescue KeyError => e
        abort e.message
      end
    end
  end

  load_defaults!
end