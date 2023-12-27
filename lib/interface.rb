require 'tty-prompt'
require 'tty-table'
require 'tty-cursor'

class CFInterface
  def initialize(board)
    @prompt = TTY::Prompt.new
    @table = TTY::Table.new(board)
    @cursor = TTY::Cursor
  end

  def get_player_choice(msg,range)
    @prompt.ask(msg, convert: :int) do |q|
      q.in = range
      q.messages[:range?] = "Choice must be within #{range}"
    end
  end

  def update_render_table(row,column,value)
    @table.row(row)[column] = value if value
    return
  end

  def get_formatted_board
    formatted_table = @table.render(:unicode,alignment: [:center],padding: [1,1]) do |renderer|
      renderer.border do
        top''
        top_mid''
        top_left''
        top_right''
      end
    end
    formatted_table
  end

  def clear_screen
    print @cursor.clear_screen
  end
end
