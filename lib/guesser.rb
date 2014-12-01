require 'pry'
require 'yaml'
require 'slop'
require 'guesser/game'
require 'guesser/player'
require 'guesser/generator'
require 'guesser/configuration'
require 'guesser/utils/file_manager'

module Guesser
  include Guesser::FileManager
  extend Guesser::Configuration

  load_defaults!
end