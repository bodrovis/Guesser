module Guesser
  class GameOptions
    def initialize(argv)
      parse_args(argv).each do |k, v|
        # attr_accessor for each possible option
        self.class.class_eval do
          attr_accessor k
        end

        # setting each option as instance variable
        self.instance_variable_set "@#{k}", v
      end
    end

    private

    def parse_args(argv)
      return defaults if argv.empty?

      options = Slop.parse(argv) do |o|
        o.integer '-o', '--points', 'Points to win (integer, greater than 0).'
        o.integer '-i', '--limit', 'Guessed number limit (integer, greater than 0).'
        o.integer '-p', '--players', 'How many players will participate (integer, greater than 0).'
        o.on '--help' do
          puts o
          exit
        end
      end.to_hash
      normalize! options
    rescue Slop::Error => e
      warn e.message
      warn "[WARNING] Using default options. Provide --help to view info about available options."
      defaults
    end

    def defaults
      CONFIG
    end

    def normalize!(opts)
      opts.delete_if {|k, v| v.to_i < 1}.merge!(defaults) {|k, v1, v2| v1}
    end
  end
end