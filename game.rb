require './player.rb'
require './generator.rb'
require './file_manager.rb'

module Guesser
  include FileManager

  WINS_TO_GO = 1

  class Game
    attr_reader :players, :winner, :secret_number

    def initialize
      @winner = nil
      puts '*' * 50
      puts 'Starting the game...'
      puts '*' * 50
      initialize_players

      until @winner do
        @players.each do |p|
          generate_secret_number(10)
          p.waiting_times << measure_time {
            p.guess == @secret_number.show ? p.guessed : puts("Fail... The number was #{@secret_number.show}")
          }

          if p.won?
            @winner = p
            break
          end
        end

        show_players_statistics
      end

      show_winner
      print_winner_to_file
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
      @players.each {|p| puts p.show_player_statistics }
    end

    def generate_secret_number(limit)
      sleep 1
      puts
      puts 'Now generating a new number to guess...'
      @secret_number = Generator.new(limit)
      puts 'Done! Try to guess it!'
    end

    def show_winner
      puts
      puts "=== We have a winner! ==="
      puts "#{@winner.name} won the match!"
      puts "Thanks for playing and see you again soon!"
    end

    def print_winner_to_file
      writer = Writer.new('game')
      writer.write("Player #{@winner.name} won (#{Time.now})!\n", @winner.show_player_statistics)
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