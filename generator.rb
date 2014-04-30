module Guesser
  attr_reader :secret_number

  class Generator
    def initialize(limit)
      @secret_number = rand(limit)
    end
  end
end