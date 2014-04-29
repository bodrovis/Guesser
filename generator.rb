module Guesser
  attr_accessor :secret_number

  class Generator
    def initialize(limit)
      @secret_number = rand(limit)
    end

    def show
      @secret_number
    end
  end
end