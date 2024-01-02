require 'tty-prompt'
require 'tty-table'
require 'tty-cursor'
require 'pastel'

pastel = Pastel.new
bar = pastel.blue("│")
GRAPHICS = {
  bar: bar,
  start: bar + " ",
  endl: " " + bar,
  mid: " " + bar + " ",
  separator: bar + Array.new(7,"    ").join(bar) + bar,
  bottom_bar: pastel.blue('└────┴────┴────┴────┴────┴────┴────┘')
}
class CFInterface
  attr_reader :player, :winner, :draw
  CHOICES = {Play: 1, Exit: 2}
  def initialize(board,valid_columns)
    @prompt = TTY::Prompt.new
    @pastel = Pastel.new
    @valid_columns = valid_columns
    @header = []
    @board = board
    @cursor = TTY::Cursor
    @players = Array.new(2,'')
    @formatted_header = ''
    @formatted_board = ''
  end

  def get_player_choice(valid_columns)
    regex = /^[#{valid_columns.join}]$/
    @prompt.ask("Choose column to drop token: ", convert: :int) do |q|
      q.required true
      q.validate regex
      q.messages[:valid?] = "Chosen column is either out of range or full"
    end
  end

  def menu_screen
    clear_screen
    welcome_message
    choice = @prompt.select("Game Menu: ", CHOICES, show_help: :always)
    exit(true) if choice == 2
    clear_screen
    set_player_name
    @prompt.keypress("\nPress any key to continue...")
  end

  def main_game(player_index,token, winner: false, draw: false)
    clear_screen
    format_board
    @prompt.ok(menu_art)
    puts get_formatted_board
    if winner
      @prompt.ok("\n#{@players[player_index]} WON!!!! 🎉🎉🎉🎉 \n")
      sleep(2)
      @prompt.keypress("Press any key to continue")
    elsif draw
      @prompt.warn("\nNo winner this time. The game ends in a draw!\n")
      sleep(2)
      @prompt.keypress("Press any key to continue")
    else
      puts "\n#{token} #{@players[player_index]}'s turn: \n\n"
    end
  end

  def set_header()
    @header = Array.new(7) {|i| @valid_columns.include?(i+1) ? @pastel.green(i+1) : @pastel.red(i+1)}
    format_header
  end

  def format_header
    bar, start, endl, mid, separator = GRAPHICS.values
    n = "\n"
    @formatted_header = separator + n + start + @header.join(" " + mid) + " " + endl + n + separator
  end

  def format_board
    bar, start, endl, mid, separator, bottom_bar = GRAPHICS.values
    n = "\n"
    formatted_board = @board.map do |row|
      separator + n + start + row.join(mid) + endl + n+ separator
    end
    @formatted_board = formatted_board.join(n) + n + bottom_bar
  end


  private

  def get_formatted_board
    @formatted_header + "\n" + @formatted_board
  end

  def set_player_name
    @prompt.ok(menu_art)
    players_helper_hash = {PlayerOne: 'one',PlayerTwo: 'two'}
    name_regex = /^[a-zA-Z ]+$/
    error_msg = "Name must only contain alphabets and space"
    puts "So lets begin, \n\n"
    result = @prompt.collect do
      players_helper_hash.each do |k, v|
        key(k).ask("Enter name of player #{v}?",default: k.to_s) do |q|
          q.validate name_regex
          q.modify   :capitalize, :strip
          q.messages[:valid?] = error_msg
        end
      end
    end
    @players = result.values
  end

  def welcome_message
    @prompt.ok(menu_art)
    puts "Welcome to Connect Four!"
    puts "Challenge a friend to a classic game of strategy and tactics."
    puts "Connect four of your colored discs in a row, either horizontally, vertically, or diagonally, to win!"
    puts "Let the game begin!\n\n"
  end

  def menu_art
    art = <<-ART
╔═══╗                     ╔╗      ╔═══╗        🔴        🟡
║╔═╗║                    ╔╝╚╗     ║╔══╝             🔴
║║ ╚╝╔══╗╔══╗╔══╗╔══╗╔══╗╚╗╔╝     ║╚══╗╔══╗╔╗╔╗╔═╗        🔴
║║ ╔╗║╔╗║║╔╗║║╔╗║║╔╗║║╔═╝ ║║      ║╔══╝║╔╗║║║║║║╔╝     🟡
║╚═╝║║╚╝║║║║║║║║║║║═╣║╚═╗ ║╚╗    ╔╝╚╗  ║╚╝║║╚╝║║║  🟡
╚═══╝╚══╝╚╝╚╝╚╝╚╝╚══╝╚══╝ ╚═╝    ╚══╝  ╚══╝╚══╝╚╝        🔴
    ART
  end

  def clear_screen
    print @cursor.clear_screen + @cursor.move_to
  end
end
