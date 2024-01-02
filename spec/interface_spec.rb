require_relative '../lib/interface'

describe CFInterface do
  let(:board) {Array.new(6) {Array.new(7,'⚫')}}
  let(:valid_columns) {Array.new(7) {|i| i+1}}

  describe '#get_player_choice' do
    subject(:game_choice) {described_class.new(board,valid_columns)}
    let(:prompt) {game_choice.instance_variable_get(:@prompt)}
    context 'whenever called' do
      it 'calls ask method with message string and integer conversion' do
        allow(prompt).to receive(:ask).and_return(rand(1..7))
        expect(game_choice.get_player_choice(valid_columns)).to be_between(1,7)
      end
    end
  end

  describe '#set_header' do
  subject(:game_header) {described_class.new(board,valid_columns)}
    context 'when trying to update header' do
      it 'changes @formatted_header and @header' do
        expect{game_header.set_header}.to change{[
          game_header.instance_variable_get(:@header),
          game_header.instance_variable_get(:@formatted_header)
        ]}
      end
    end
  end

  describe '#menu_screen' do
    subject(:game_screen){described_class.new(board,valid_columns)}
    let(:prompt) {game_screen.instance_variable_get(:@prompt)}
    context 'when menu screen is called' do
      it 'sets the player names' do
        allow(prompt).to receive(:select).and_return(1)
        allow(prompt).to receive(:ok)
        allow(prompt).to receive(:keypress)
        allow(prompt).to receive(:collect).and_return({Player1: "Rahib",Player2: "Pranav"})
        allow(game_screen).to receive(:puts)
        allow(game_screen).to receive(:clear_screen)
        expect{game_screen.menu_screen}.to change{game_screen.instance_variable_get(:@players)}.to(["Rahib","Pranav"])
      end
    end
  end
end
