module Guesser
  class Player
    attr_reader :points, :name, :waiting_times
    attr_accessor :number_to_guess

    def initialize(name)
      points = 0
      @name = name
      @waiting_times = []
    end

    def show_player_statistics
      "\n" + "=" * 10 + "\n" +
          "=== #{name} statistics:" + "\n" +
          "Points: #{points}" + "\n" +
          "Avg waiting time #{avg_waiting}" + "\n" +
          "=" * 10 + "\n\n"
    end

    def guess
      puts "=== It's now #{name}'s turn. Enter your guess:"
      gets.to_i
    end

    def guessed
      puts "You've guessed!"
      @number_to_guess = nil # Player guessed this number, a new one would be needed
      @points += 1
    end

    def won?
      points >= POINTS_TO_GO
    end

    def avg_waiting
      begin
        (waiting_times.inject(:+) || 0) / waiting_times.count
      rescue ZeroDivisionError
        "n/a"
      end
    end
  end
end