# frozen_string_literal: true

require_relative 'game_logic'
require_relative 'interface'

class ConnectFour
  attr_reader :player1, :player2, :board

  def initialize()
    @game = CFGameLogic.new
    @interface = CFInterface.new(@game.board)
  end
end
