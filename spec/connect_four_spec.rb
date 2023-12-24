require_relative '../lib/connect_four'


describe ConnectFour do
  PLAYER1_SYMBOL = described_class::PLAYER1_SYMBOL
  EMPTY_SYMBOL = described_class::EMPTY_SYMBOL
  PLAYER2_SYMBOL = described_class::PLAYER2_SYMBOL
  p1 = "Rahib"
  p2 = "Pranav"
  let(:create_instance) {described_class.new(p1,p2)}

  describe '#drop_coin' do
    context 'when game starts' do
      subject(:game_start) {create_instance}
      it 'contains same element all over the board' do
        expect(all_same?(game_start.board)).to be true
      end
    end

    context 'when player drops a coin in first column' do
      subject(:game_move) {create_instance}
      it 'contains coin at bottom of first column' do
        game_move.drop_coin(0)
        expect(game_move.board[-1][0]).to_not eq(EMPTY_SYMBOL)
      end
    end

    context 'when player drops a coin in fifth column' do
      subject(:game_move) {create_instance}
      it 'contains coin at bottom of fifth column' do
        game_move.drop_coin(4)
        expect(game_move.board[-1][4]).to_not eq(EMPTY_SYMBOL)
      end
    end

    context 'when player drops a coin in third column twice' do
      subject(:game_move) {create_instance}
      it 'contains coin at last and second last row of third column' do
        game_move.drop_coin(2)
        game_move.drop_coin(2)
        expect(game_move.board[-2][2]).to_not eq(EMPTY_SYMBOL)
      end
    end
    context 'when player drops a coin in second column twice and in seventh column once' do
      subject(:game_move) {create_instance}
      it 'contains two coins in second row and one coin in seventh column' do
        game_move.drop_coin(1)
        game_move.drop_coin(1)
        game_move.drop_coin(6)
        expect(game_move.board[-1][1]).to_not eq(EMPTY_SYMBOL)
        expect(game_move.board[-2][1]).to_not eq(EMPTY_SYMBOL)
        expect(game_move.board[-1][6]).to_not eq(EMPTY_SYMBOL)
      end
    end
    context 'when player drops a coin in any column' do
      subject(:game_move) {create_instance}
      it 'should not affect other cells' do
        game_move.drop_coin(0)
        expect(game_move.board[-1][0]).to_not eq(EMPTY_SYMBOL)
        temp_board = game_move.board
        temp_board[-1][0] = EMPTY_SYMBOL
        expect(all_same?(temp_board)).to be true
      end
    end
    context 'when player drops two coins' do
      subject(:game_move) {create_instance}
      it 'second coin must not be equal to first coin' do
        game_move.drop_coin(0)
        game_move.drop_coin(4)
        expect(game_move.board[-1][0]).to_not eq(game_move.board[-1][4])
      end
    end
  end
end

def all_same?(arr)
  arr.all? {|row| row.all?(EMPTY_SYMBOL)}
end
