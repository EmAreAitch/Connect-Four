require_relative '../lib/game_logic'

describe CFGameLogic do
  PLAYER1_TOKEN = described_class::PLAYER1_TOKEN
  EMPTY_TOKEN = described_class::EMPTY_TOKEN
  PLAYER2_TOKEN = described_class::PLAYER2_TOKEN
  TOTAL_ROWS = described_class::ROWS
  TOTAL_COLUMNS = described_class::COLUMNS
  TOTAL_CELLS = TOTAL_ROWS * TOTAL_COLUMNS

  describe '#get_empty_row_of' do
    context 'when game starts and first column is chosen' do
      subject(:game_start) {described_class.new}
      it 'returns 5' do
        expect(game_start.get_empty_row_of(1)).to eq(5)
      end
    end
    context 'when first column has 2 coin already' do
      subject(:game_mid) {described_class.new}
      let(:grid) {game_mid.instance_variable_get(:@board)}
      it 'returns 3' do
        2.times {|i| grid[TOTAL_ROWS-1-i][0] = PLAYER1_TOKEN}
        expect(game_mid.get_empty_row_of(1)).to eq(3)
      end
    end

    context 'when third column is full' do
      subject(:game_mid) {described_class.new}
      let(:grid) {game_mid.instance_variable_get(:@board)}
      it 'returns 3' do
        6.times {|i| grid[TOTAL_ROWS-1-i][2] = PLAYER1_TOKEN}
        expect(game_mid.get_empty_row_of(3)).to eq(-1)
      end
    end

    context 'when given column is invalid' do
      subject(:game_mid) {described_class.new}
      it 'returns nil' do
        expect(game_mid.get_empty_row_of(8)).to be_nil
      end
    end
  end

  describe '#change_player_turn' do
  subject(:game) {described_class.new}
    context 'when trying to change player turn two times' do
      it 'changes @current_token to initial' do
        starting_token = game.instance_variable_get(:@current_token)
        expect{game.change_player_turn}.to change {game.instance_variable_get(:@current_token)}.by 1
        expect{game.change_player_turn}.to change {game.instance_variable_get(:@current_token)}.to starting_token
        game.change_player_turn
      end
    end
  end

  describe '#set_token' do
    context 'when token is setup at 3 row and 2 column' do
      subject(:game){described_class.new}
      it 'sets the @board[2][1] to current_token' do
        current_token = game.instance_variable_get(:@current_token)
        token = described_class::TOKEN_CYCLE[current_token]
        expect{game.set_token(2,1)}.to change{game.instance_variable_get(:@board)[2][1]}.to token
      end
    end
    context 'when invalid row or column' do
      subject(:game){described_class.new}
      it 'does not change the board' do
        expect{game.set_token(6,1)}.to_not change{game.instance_variable_get(:@board)}
        expect{game.set_token(2,10)}.to_not change{game.instance_variable_get(:@board)}
        expect{game.set_token(8,-1)}.to_not change{game.instance_variable_get(:@board)}
      end
    end
  end


  describe '#won_by_diagonal?' do
    subject(:game_diagonal_win) {described_class.new}
    let(:grid) {game_diagonal_win.instance_variable_get(:@board)}
    context 'when last winning move is at the upper right' do
      it 'returns true' do
        4.times {|i| grid[-1 - i][i] = PLAYER1_TOKEN}
        expect(game_diagonal_win.won_by_diagonal?([2,3])).to be true
      end
    end
    context 'when last winning move is at the upper left' do
      it 'returns true' do
        4.times {|i| grid[-1 - i][3 - i] = PLAYER1_TOKEN}
        expect(game_diagonal_win.won_by_diagonal?([2,0])).to be true
      end
    end
    context 'when last winning move is at the bottom right ' do
      it 'returns true' do
        4.times {|i| grid[-1 - i][3 - i] = PLAYER1_TOKEN}
        expect(game_diagonal_win.won_by_diagonal?([5,3])).to be true
      end
    end
    context 'when last winning move is at the bottom left' do
      it 'returns true' do
        4.times {|i| grid[-1 - i][i] = PLAYER1_TOKEN}
        expect(game_diagonal_win.won_by_diagonal?([5,0])).to be true
      end
    end

    context 'when last winning move is at the top right of the board' do
      it 'returns true' do
        4.times {|i| grid[3 - i][-4 + i] = PLAYER1_TOKEN}
        expect(game_diagonal_win.won_by_diagonal?([0,6])).to be true
      end
    end

    context 'when last winning move is somewhere in the middle of diagonal' do
      it 'returns true' do
        4.times {|i| grid[-1 - i][i] = PLAYER1_TOKEN}
        expect(game_diagonal_win.won_by_diagonal?([3,2])).to be true
      end
    end

    context 'when player didnt won by diagonal' do
      it 'returns false' do
        3.times {|i| grid[-1 - i][i] = PLAYER1_TOKEN}
        expect(game_diagonal_win.won_by_diagonal?([4,1])).to be false
      end
    end
  end





  describe '#won_by_horizontal?' do
    subject(:game_horizontal_win) {described_class.new}
    let(:grid) {game_horizontal_win.instance_variable_get(:@board)}
    context 'when last winning move is at the right' do
      it 'returns true' do
        4.times {|i| grid[-1][i] = PLAYER1_TOKEN}
        expect(game_horizontal_win.won_by_horizontal?([5,3])).to be true
      end
    end
    context 'when last winning move is at the left' do
      it 'returns true' do
        4.times {|i| grid[-1][3 - i] = PLAYER1_TOKEN}
        expect(game_horizontal_win.won_by_horizontal?([5,0])).to be true
      end
    end

    context 'when last winning move is somewhere in the middle' do
      it 'returns true' do
        4.times {|i| grid[-1][i] = PLAYER1_TOKEN}
        expect(game_horizontal_win.won_by_horizontal?([5,1])).to be true
      end
    end
    context 'when player didnt won by horizontal' do
      it 'returns false' do
        3.times {|i| grid[-1][i] = PLAYER1_TOKEN}
        expect(game_horizontal_win.won_by_horizontal?([5,1])).to be false
      end
    end
  end





  describe '#won_by_vertical?' do
    subject(:game_vertical_win) {described_class.new}
    let(:grid) {game_vertical_win.instance_variable_get(:@board)}
    context 'when last winning move is at the top' do
      it 'returns true' do
        4.times {|i| grid[-1-i][0] = PLAYER1_TOKEN}
        expect(game_vertical_win.won_by_vertical?([2,0])).to be true
      end
    end
    context 'when player didnt won by vertical move' do
      it 'returns false' do
        3.times {|i| grid[-1-i][0] = PLAYER1_TOKEN}
        expect(game_vertical_win.won_by_vertical?([-3,0])).to be false
      end
    end
  end
end
