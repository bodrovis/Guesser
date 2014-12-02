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

      begin
        options = Slop.parse(argv, strict: true, help: true,
                             banner: 'Welcome to the Guesser game. Here is the list of available options:') do
          on '-o', '--points', 'Points to win (integer, greater than 0).', as: Integer, argument: true
          on '-i', '--limit', 'Guessed number limit (integer, greater than 0).', as: Integer, argument: true
          on '-p', '--players', 'How many players will participate (integer, greater than 0).', as: Integer, argument: true
        end.to_hash

        normalize! options
      rescue Slop::Error => e
        warn e.message
        warn "[WARNING] Using default options. Provide --help to view info about available options."
        defaults
      end
    end

    def defaults
      CONFIG
    end

    def normalize!(opts)
      opts.reject! {|k, v| v.to_i < 1}.merge!(defaults) {|k, v1, v2| v1}
    end
  end
end