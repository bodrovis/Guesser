module Guesser
  class Generator
    attr_reader :secret_number

    def initialize(limit = 10)
      @secret_number = rand(limit)
    end
  end
end