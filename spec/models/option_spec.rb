RSpec.describe Option do
  describe "#vote!" do
    context "when the option is new has no votes and its voted" do
      # Arrange
      subject(:option) { described_class.new() }
      it "should increase +1 to voted_times" do
        # Act
        option.vote!
        # Assert
        expect(option.voted_times).to eq(1)
      end
    end
  end
end
