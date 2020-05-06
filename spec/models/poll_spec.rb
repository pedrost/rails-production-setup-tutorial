RSpec.describe Poll do
  describe "#viewed!" do
    context "when the poll is new, had has no views and it is viewed" do
      # Arrange
      subject(:poll) { described_class.new() }

      it "should increase +1 to views" do
        # Act
        poll.viewed!
        # Assert
        expect(poll.views).to eq(1)
      end
    end
  end
end
