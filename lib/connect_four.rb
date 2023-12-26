# frozen_string_literal: true
require 'tty-prompt'

class ConnectFour
  attr_reader :player1, :player2, :board

  PLAYER1_SYMBOL = '🔴'
  EMPTY_SYMBOL = '⚫'
  PLAYER2_SYMBOL = '🟡'
  SYMBOL_CYCLE = [PLAYER1_SYMBOL, PLAYER2_SYMBOL]

  def initialize(player1 = 'Player1', player2 = 'Player2')
    @player1 = player1
    @player2 = player2
    @board = Array.new(6) {Array.new(7,EMPTY_SYMBOL)}
    @current_token = 0
    @prompt = TTY::Prompt.new
  end

  def drop_token(column_index)
    row_index =  @board.find_index {|row| row[column_index] != EMPTY_SYMBOL} || 6
    row_index -= 1
    @board[row_index][column_index] = SYMBOL_CYCLE[@current_token]
    @current_token  = (@current_token + 1) % 2
    return [row_index, column_index]
  end

  def won_by_diagonal?(last_move)
    r, c = last_move
    token = @board[r][c]
    upp_l  = upp_r = bot_l = bot_r = 0
    3.times {|i| (safe_board_get(r-i-1,c-i-1) == token) ? upp_l += 1 : break}
    3.times {|i| (safe_board_get(r+i+1,c+i+1) == token) ? bot_r += 1 : break}
    return true if (upp_l + bot_r + 1) >= 4
    3.times {|i| (safe_board_get(r-i-1,c+i+1) == token) ? upp_r += 1 : break}
    3.times {|i| (safe_board_get(r+i+1,c-i-1) == token) ? bot_l += 1 : break}
    return (upp_r + bot_l + 1) >= 4
  end

  def won_by_horizontal?(last_move)
    r, c = last_move
    token = @board[r][c]
    left = right = 0
    3.times {|i| (safe_board_get(r,c+i+1) == token) ? left += 1 : break}
    3.times {|i| (safe_board_get(r,c-i-1) == token) ? right += 1 : break}
    return left + right + 1 >= 4
  end

  def won_by_vertical?(last_move)
    r, c = last_move
    token = @board[r][c]
    bottom = 0
    3.times {|i| (safe_board_get(r+i+1,c) == token) ? bottom += 1 : break}
    return bottom + 1 >= 4
  end

  def get_player_choice(msg,range)
    @prompt.ask(msg, convert: :int) do |q|
      q.in = range
      q.messages[:range?] = "Choice must be within #{range}"
    end
  end
  private

  def safe_board_get(row,column)
    return @board[row][column] if row.between?(0,@board.length-1) and column.between?(0, @board[row].length-1)
  end
end
