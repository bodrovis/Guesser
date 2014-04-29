require './player.rb'
require './generator.rb'
require './utils/file_manager.rb'

module Guesser
  include FileManager

  WINS_TO_GO = 3
  NUMBER_LIMIT = 10

  class Game
    attr_reader :players, :winner

    def initialize
      @winner = nil
      puts '*' * 50
      puts 'Starting the game...'
      puts '*' * 50

      initialize_players
      play
      show_winner
      print_winner_to_file
    end

    def play
      until @winner do
        @players.each do |player|
          generate_secret_number_for player
          player.waiting_times << measure_time {
            player.guess == player.number_to_guess.show ? player.guessed : puts("Try again next turn!")
          }

          if player.won?
            @winner = player
            break
          end
        end

        show_players_statistics
      end
    end

    private

    def initialize_players
      players_count = 0

      while players_count <= 0 do
        puts 'How many players?'
        players_count = gets.to_i
      end

      puts "Okay, starting with #{players_count} player(s)..."

      @players = []
      players_count.times do |i|
        puts "Enter a name for player ##{i + 1}"
        @players << Player.new(gets.strip)
      end
    end

    def show_players_statistics
      @players.each { |p| puts p.show_player_statistics }
    end

    def generate_secret_number_for(player)
      sleep 1
      puts "\nPreparing a number to guess..."
      player.number_to_guess ||= Generator.new(NUMBER_LIMIT)
    end

    def show_winner
      puts "\n=== We have a winner! ==="
      puts "#{@winner.name} won the match!"
      puts "Thanks for playing and see you again soon!"
    end

    def print_winner_to_file
      writer = Writer.new('game')
      writer.write("Player #{@winner.name} won at #{Time.now}\n", @winner.show_player_statistics)
    end

    def measure_time
      if block_given?
        time_before = Time.now
        yield
        waited_for = Time.now - time_before
        puts "You were thinking for #{waited_for}s"
        waited_for
      end
    end
  end
end