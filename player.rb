module Guesser
  class Player
    attr_accessor :wins, :name, :waiting_times

    def initialize(name)
      @wins = 0
      @name = name
      @waiting_times = []
    end

    def show_player_statistics
      "\n" +
      "=" * 10 + "\n" +
      "=== #{name} statistics:"  + "\n" +
      "Wins: #{wins}"  + "\n" +
       "Avg waiting time #{avg_waiting}s"  + "\n" +
      "=" * 10 + "\n" +
      "\n"
    end

    def guess
      puts "=== It's now #{name}'s turn. Enter your guess:"
      gets.to_i
    end

    def guessed
      puts "You've guessed!"
      self.wins += 1
    end

    def won?
      wins >= WINS_TO_GO
    end

    def avg_waiting
      (waiting_times.inject(:+) || 0) / (waiting_times.count == 0 ? 1 : waiting_times.count)
    end
  end
end