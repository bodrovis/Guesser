require 'spec_helper'

module Guesser
  describe Generator do
    it "should return random value within specified limit" do
      generated = Generator.new(5)
      generated.secret_number.should < 5
    end
  end
end