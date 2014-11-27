require 'spec_helper'

module Guesser
  describe Generator do
    it "should return random value within specified limit" do
      generated = Generator.new(5)
      expect(generated.secret_number).to be < 5
    end
  end
end