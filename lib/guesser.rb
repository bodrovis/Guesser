require 'yaml'
require 'slop'
require 'messages_dictionary'
require 'guesser/game'
require 'guesser/player'
require 'guesser/game_options'
require 'guesser/utils/file_manager'
require 'guesser/utils/hash'

module Guesser
  include Guesser::FileManager
  AVAILABLE_OPTIONS = [:points, :limit, :players]

  class << self
    include MessagesDictionary
    has_messages_dictionary file: 'errors.yml', dir: 'lib/guesser/messages', method: :abort

    def load_defaults!
      const_set(:CONFIG, {})
      config_file = File.expand_path('../../config.yml', __FILE__)
      yaml_conf = YAML.load_file(config_file).symbolize_keys

      AVAILABLE_OPTIONS.each do |k|
        value = yaml_conf.fetch(k) do
          raise KeyError, pretty_output(:key_not_found, key: k) {|msg| msg}
        end
        value = Integer(value)
        raise RangeError, pretty_output(:value_incorrect, value: value, key: k) if value < 1
        CONFIG[k] = value
      end
    rescue Errno::ENOENT
      pretty_output :file_not_found
    rescue NoMethodError
      pretty_output :empty_config
    rescue RangeError => e
      abort e.message
    rescue KeyError => e
      abort e.message
    end
  end

  load_defaults!
end