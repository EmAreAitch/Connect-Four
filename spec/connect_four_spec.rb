require_relative '../lib/connect_four'


describe ConnectFour do
  PLAYER1_SYMBOL = described_class::PLAYER1_SYMBOL
  EMPTY_SYMBOL = described_class::EMPTY_SYMBOL
  PLAYER2_SYMBOL = described_class::PLAYER2_SYMBOL
  TOTAL_CELLS = 6 * 7

  describe '#drop_token' do
    context 'when game starts' do
      subject(:game_start) {described_class.new}
      it 'contains same element all over the board' do
        result  = game_start.board.all? {|row| row.all?(EMPTY_SYMBOL)}
        expect(result).to be true
      end
    end

    context 'when player drops a token in first column' do
      subject(:game_move) {described_class.new}
      it 'contains token at bottom of first column' do
        game_move.drop_token(0)
        expect(game_move.board[-1][0]).to_not eq(EMPTY_SYMBOL)
      end
    end

    context 'when player drops a token in fifth column' do
      subject(:game_move) {described_class.new}
      it 'contains token at bottom of fifth column' do
        game_move.drop_token(4)
        expect(game_move.board[-1][4]).to_not eq(EMPTY_SYMBOL)
      end
    end

    context 'when player drops a token in third column twice' do
      subject(:game_move) {described_class.new}
      it 'contains token at last and second last row of third column' do
        game_move.drop_token(2)
        game_move.drop_token(2)
        expect(game_move.board[-2][2]).to_not eq(EMPTY_SYMBOL)
      end
    end
    context 'when player drops a token in second column twice and in seventh column once' do
      subject(:game_move) {described_class.new}
      it 'contains two tokens in second row and one token in seventh column' do
        game_move.drop_token(1)
        game_move.drop_token(1)
        game_move.drop_token(6)
        expect(game_move.board[-1][1]).to_not eq(EMPTY_SYMBOL)
        expect(game_move.board[-2][1]).to_not eq(EMPTY_SYMBOL)
        expect(game_move.board[-1][6]).to_not eq(EMPTY_SYMBOL)
      end
    end
    context 'when player drops a token in any column' do
      subject(:game_move) {described_class.new}
      it 'should not affect other cells' do
        game_move.drop_token(0)
        number_of_empty_places = game_move.board.reduce(0) {|acc, row| acc + row.count(EMPTY_SYMBOL)}
        expect(game_move.board[-1][0]).to_not eq(EMPTY_SYMBOL)
        expect(number_of_empty_places).to eq(TOTAL_CELLS - 1)
      end
    end
    context 'when player drops two tokens' do
      subject(:game_move) {described_class.new}
      it 'second token must not be equal to first token' do
        game_move.drop_token(0)
        game_move.drop_token(4)
        expect(game_move.board[-1][0]).to_not eq(game_move.board[-1][4])
      end
    end
  end





  describe '#won_by_diagonal?' do
    subject(:game_diagonal_win) {described_class.new}
    let(:grid) {game_diagonal_win.instance_variable_get(:@board)}
    context 'when last winning move is at the upper right' do
      it 'returns true' do
        4.times {|i| grid[-1 - i][i] = PLAYER1_SYMBOL}
        expect(game_diagonal_win.won_by_diagonal?([2,3])).to be true
      end
    end
    context 'when last winning move is at the upper left' do
      it 'returns true' do
        4.times {|i| grid[-1 - i][3 - i] = PLAYER1_SYMBOL}
        expect(game_diagonal_win.won_by_diagonal?([2,0])).to be true
      end
    end
    context 'when last winning move is at the bottom right ' do
      it 'returns true' do
        4.times {|i| grid[-1 - i][3 - i] = PLAYER1_SYMBOL}
        expect(game_diagonal_win.won_by_diagonal?([5,3])).to be true
      end
    end
    context 'when last winning move is at the bottom left' do
      it 'returns true' do
        4.times {|i| grid[-1 - i][i] = PLAYER1_SYMBOL}
        expect(game_diagonal_win.won_by_diagonal?([5,0])).to be true
      end
    end

    context 'when last winning move is at the top right of the board' do
      it 'returns true' do
        4.times {|i| grid[3 - i][-4 + i] = PLAYER1_SYMBOL}
        expect(game_diagonal_win.won_by_diagonal?([0,6])).to be true
      end
    end

    context 'when last winning move is somewhere in the middle of diagonal' do
      it 'returns true' do
        4.times {|i| grid[-1 - i][i] = PLAYER1_SYMBOL}
        expect(game_diagonal_win.won_by_diagonal?([3,2])).to be true
      end
    end

    context 'when player didnt won by diagonal' do
      it 'returns false' do
        3.times {|i| grid[-1 - i][i] = PLAYER1_SYMBOL}
        expect(game_diagonal_win.won_by_diagonal?([4,1])).to be false
      end
    end
  end





  describe '#won_by_horizontal?' do
    subject(:game_horizontal_win) {described_class.new}
    let(:grid) {game_horizontal_win.instance_variable_get(:@board)}
    context 'when last winning move is at the right' do
      it 'returns true' do
        4.times {|i| grid[-1][i] = PLAYER1_SYMBOL}
        expect(game_horizontal_win.won_by_horizontal?([5,3])).to be true
      end
    end
    context 'when last winning move is at the left' do
      it 'returns true' do
        4.times {|i| grid[-1][3 - i] = PLAYER1_SYMBOL}
        expect(game_horizontal_win.won_by_horizontal?([5,0])).to be true
      end
    end

    context 'when last winning move is somewhere in the middle' do
      it 'returns true' do
        4.times {|i| grid[-1][i] = PLAYER1_SYMBOL}
        expect(game_horizontal_win.won_by_horizontal?([5,1])).to be true
      end
    end
    context 'when player didnt won by horizontal' do
      it 'returns false' do
        3.times {|i| grid[-1][i] = PLAYER1_SYMBOL}
        expect(game_horizontal_win.won_by_horizontal?([5,1])).to be false
      end
    end
  end





  describe '#won_by_vertical?' do
    subject(:game_vertical_win) {described_class.new}
    let(:grid) {game_vertical_win.instance_variable_get(:@board)}
    context 'when last winning move is at the top' do
      it 'returns true' do
        4.times {|i| grid[-1-i][0] = PLAYER1_SYMBOL}
        expect(game_vertical_win.won_by_vertical?([2,0])).to be true
      end
    end
    context 'when player didnt won by vertical move' do
      it 'returns false' do
        3.times {|i| grid[-1-i][0] = PLAYER1_SYMBOL}
        expect(game_vertical_win.won_by_vertical?([-3,0])).to be false
      end
    end
  end

  describe '#get_player_choice' do
    subject(:game_choice) {described_class.new}
    let(:prompt) {game_choice.instance_variable_get(:@prompt)}
    context 'whenever called' do
      it 'calls ask method' do
        expect(prompt).to receive(:ask)
        game_choice.get_player_choice('Choose within the range 1 - 9','1-9')
      end
    end
  end
end
