require_relative '../lib/interface'

describe CFInterface do
  let(:board) {Array.new(6) {Array.new(7,'⚫')}}
  describe '#get_player_choice' do
    subject(:game_choice) {described_class.new(board)}
    let(:prompt) {game_choice.instance_variable_get(:@prompt)}
    context 'whenever called' do
      it 'calls ask method with message string and integer conversion' do
        allow(prompt).to receive(:ask).and_return(rand(1..9))
        msg = 'Choose within the range 1 - 9'
        rng = 1..9
        expect(game_choice.get_player_choice(msg,rng)).to be_between(1,9)
      end
    end
  end

  describe '#get_formatted_board' do
  subject(:game_board) {described_class.new(board)}
  let(:table){game_board.instance_variable_get(:@table)}
    context 'when trying to display board' do
      it 'calls render method' do
        expect(table).to receive(:render)
        game_board.get_formatted_board
      end
    end
  end

end
