# frozen_string_literal: true

require_relative 'game_logic'
require_relative 'interface'

class ConnectFour
  def initialize()
    @game = CFGameLogic.new
    @interface = CFInterface.new(@game.board,@game.valid_columns)
  end

  def start_game
    loop do
      @interface.menu_screen
      @interface.set_header
      loop do
        @interface.main_game(@game.player_index,@game.last_token)
        valid_columns = @game.valid_columns
        col_choice = @interface.get_player_choice(valid_columns)
        row_choice = @game.get_last_pos_at(col_choice)
        @game.set_token(row_choice,col_choice)
        if row_choice == 1
          @game.mark_column_full(col_choice)
          @interface.set_header
        end
        if @game.won?([row_choice-1, col_choice-1])
          @interface.main_game(@game.player_index,@game.last_token, winner: true)
          break
        elsif @game.draw?
          @interface.main_game(@game.player_index,@game.last_token, draw: true)
          break
        end
        @game.change_player_turn
      end
      @game.reset_board
    end
  end
end
