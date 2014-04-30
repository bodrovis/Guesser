require 'spec_helper'

module Guesser
  describe Player do
    let(:player) {Player.new('test_player')}

    it "should have zero points by default" do
      player.points.should eq(0)
    end

    it "should have no waiting times" do
      player.waiting_times.should be_empty
    end

    it "should increment player's points when guessed" do
      expect { player.guessed }.to change {player.points}.by(1)
    end

    it "should say when the player won the game" do
      player.stub(:points).and_return(POINTS_TO_GO - 1)
      player.won?.should be_false
      player.stub(:points).and_return(POINTS_TO_GO)
      player.won?.should be_true
    end

    it "should count average waiting time properly" do
      player.stub(:waiting_times).and_return([2, 2, 2, 2])
      player.avg_waiting.should eq(2)
    end

    it "should return not available when waiting times available" do
      player.stub(:waiting_times).and_return([])
      player.avg_waiting.should eq("n/a")
    end
  end
end