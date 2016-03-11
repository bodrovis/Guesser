module Guesser
  class Game
    include MessagesDictionary
    attr_reader :options, :output
    attr_accessor :winner, :players

    def initialize(output, argv)
      @output, @options, @players = output, GameOptions.new(argv), []
      self.class.class_exec do
        has_messages_dictionary file: 'info.yml', dir: 'lib/guesser/messages',
                                output: output
      end
    end

    def start
      welcome
      initialize_players
      play
      show_winner
      print_winner_to_file
    end

    private

    def play
      until winner do
        players.each do |player|
          sleep 1
          pretty_output 'players.turn', name: player.name
          player.generate_number_to_guess!(options.limit)
          player.waiting_times << measure_time do
            pretty_output 'guesses.enter'
            if player.guessed?
              pretty_output 'guesses.guessed'
              player.guessed!
            else
              pretty_output 'guesses.wrong'
            end
          end

          if player.won?(self)
            self.winner = player
            break
          end
        end

        show_players_statistics
      end
    end

    def welcome
      pretty_output 'welcome.intro'
      pretty_output 'welcome.rules', limit: options.limit - 1
      pretty_output 'welcome.rules2', points: options.points
    end

    def initialize_players
      pretty_output 'players.count', players_count: options.players

      options.players.times do |i|
        pretty_output 'players.enter_name', num: i + 1
        players << Player.new($stdin.gets.strip)
      end
    end

    def show_players_statistics
      players.each { |p| output.puts p.show_player_statistics }
    end

    def show_winner
      pretty_output 'winner.announce'
      pretty_output 'winner.name', name: winner.name
      pretty_output 'winner.outro'
    end

    def print_winner_to_file
      writer = FileManager::Writer.new('game-')
      writer << [pretty_output('winner.won_at', name: winner.name, time: Time.now) {|msg| msg},
                 winner.show_player_statistics]
    end

    def measure_time
      if block_given?
        time_before = Time.now
        yield
        waited_for = Time.now - time_before
        pretty_output 'guesses.time_passed', time: waited_for
        waited_for
      end
    end
  end
end