require 'pry'
require 'yaml'
require 'guesser/game'
require 'guesser/player'
require 'guesser/generator'
require 'guesser/configuration'
require 'guesser/utils/file_manager'

module Guesser
  extend FileManager
  extend Configuration

  load_defaults!
end