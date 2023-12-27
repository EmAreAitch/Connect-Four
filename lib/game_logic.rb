# frozen_string_literal: true

class CFGameLogic
  attr_reader :board
  PLAYER1_TOKEN = '🔴'
  EMPTY_TOKEN = '⚫'
  PLAYER2_TOKEN = '🟡'
  TOKEN_CYCLE = [PLAYER1_TOKEN, PLAYER2_TOKEN]
  ROWS = 6
  COLUMNS = 7

  def initialize
    @board = Array.new(ROWS) {Array.new(COLUMNS, EMPTY_TOKEN)}
    @current_token = 0
  end

  def set_token(row_index, column_index)
    @board[row_index][column_index] = TOKEN_CYCLE[@current_token] if valid_cell?(row_index,column_index)
    return nil
  end

  def change_player_turn()
    @current_token = (@current_token + 1) % 2
    return nil
  end

  def get_empty_row_of(column_index)
    return unless (0...COLUMNS).include?(column_index)
    row_index =  @board.find_index {|row| row[column_index-1] != EMPTY_TOKEN} || ROWS
    row_index -= 1
    row_index
  end

  def game_over?(move)
    return won_by_vertical(move) || won_by_horizontal(move) || won_by_diagonal(move)
  end

  def won_by_diagonal?(last_move)
    r, c = last_move
    token = @board[r][c]
    return if token == EMPTY_TOKEN
    upp_l  = upp_r = bot_l = bot_r = 0
    3.times {|i| (get_cell(r-i-1,c-i-1) == token) ? upp_l += 1 : break}
    3.times {|i| (get_cell(r+i+1,c+i+1) == token) ? bot_r += 1 : break}
    return true if (upp_l + bot_r + 1) >= 4
    3.times {|i| (get_cell(r-i-1,c+i+1) == token) ? upp_r += 1 : break}
    3.times {|i| (get_cell(r+i+1,c-i-1) == token) ? bot_l += 1 : break}
    return (upp_r + bot_l + 1) >= 4
  end


  def won_by_horizontal?(last_move)
    r, c = last_move
    token = @board[r][c]
    return if token == EMPTY_TOKEN
    left = right = 0
    3.times {|i| (get_cell(r,c+i+1) == token) ? left += 1 : break}
    3.times {|i| (get_cell(r,c-i-1) == token) ? right += 1 : break}
    return left + right + 1 >= 4
  end

  def won_by_vertical?(last_move)
    r, c = last_move
    token = @board[r][c]
    return if token == EMPTY_TOKEN
    bottom = 0
    3.times {|i| (get_cell(r+i+1,c) == token) ? bottom += 1 : break}
    return bottom + 1 >= 4
  end

  def get_cell(row,column)
    return @board[row][column] if valid_cell?(row,column)
  end

  private

  def valid_cell?(row,column)
    (0...ROWS).include?(row) and (0...COLUMNS).include?(column)
  end
end
