require 'spec_helper'

module Guesser
  describe Player do
    let(:player) {Player.new('test_player')}
    let(:game) {Game.new(STDOUT, {})}

    it "should have zero points by default" do
      expect(player.points).to eq(0)
    end

    it "should have no waiting times" do
      expect(player.waiting_times).to be_empty
    end

    it "should increment player's points when guessed" do
      expect { player.guessed }.to change {player.points}.by(1)
    end

    it "should say when the player won the game" do
      allow(player).to receive(:points).and_return(CONFIG[:POINTS_TO_GO] - 1)
      expect(player.won?(game)).to be_falsy
      allow(player).to receive(:points).and_return(CONFIG[:POINTS_TO_GO])
      expect(player.won?(game)).to be_truthy
    end

    it "should count average waiting time properly" do
      allow(player).to receive(:waiting_times).and_return([2, 2, 2, 2])
      expect(player.avg_waiting).to eq(2)
    end

    it "should return not available when waiting times available" do
      allow(player).to receive(:waiting_times).and_return([])
      expect(player.avg_waiting).to eq("n/a")
    end
  end
end