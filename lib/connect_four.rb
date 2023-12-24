# frozen_string_literal: true

class ConnectFour
  attr_reader :player1, :player2, :board

  PLAYER1_SYMBOL = '🔴'
  EMPTY_SYMBOL = '⚫'
  PLAYER2_SYMBOL = '🟡'
  SYMBOL_CYCLE = [PLAYER1_SYMBOL, PLAYER2_SYMBOL]

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @board = [[EMPTY_SYMBOL]*7] * 6
    @current_coin = 0
  end

  def drop_coin(column_index)
    row_index =  @board.find_index {|row| row[column_index] != EMPTY_SYMBOL} || 0
    row_index -= 1
    @board[row_index][column_index] = SYMBOL_CYCLE[@current_coin]
    @current_coin  = (@current_coin + 1) % 2
    return [row_index, column_index]
  end
end
