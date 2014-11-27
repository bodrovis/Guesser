require 'slop'

module Parser
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
      puts "Using default options. Provide --help to view info about available options."
      defaults
    end
  end

  private

  def defaults
    {points: ::Guesser::POINTS_TO_GO, limit: ::Guesser::NUMBER_LIMIT, players: ::Guesser::PLAYERS}
  end

  def normalize!(opts)
    opts.reject! {|k, v| v.to_i < 1}.merge!(defaults) {|k, v1, v2| v1}
  end
end