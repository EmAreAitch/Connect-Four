# frozen_string_literal: true

# masti
class ConnectFour
  attr_reader :player1, :player2

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def play
    puts 'Welcome to connect four'
  end
end
