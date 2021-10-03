require_relative "positions"
require_relative "save_positions"
require_relative "board_data"
require "byebug"

class Game
  def initialize(save_)
    @save_in_database = save_
    @positions = Positions.new
    @boards = []
    @save_positions = SavePositions.new
  end

  def start_game()
    @positions = Positions.new
    @positions.set_initial_board
    @boards=[]
    next_white_move
  end

  def next_white_move
    movements = @positions.available_white_moves.to_a
    return if (is_it_game_over(movements.length))
    add_recent_board(movements.length)
    print_last_board_info
    rnd = rand(movements.length)
    last_movement = movements[rnd]
    @positions.update_board_details_after_white_move(last_movement)
    @positions.set_initial_board
    next_black_move
  end

  def next_black_move
    movements = @positions.available_black_moves.to_a
    return if (is_it_game_over(movements.length))
    add_recent_board(movements.length)
    print_last_board_info
    rnd = rand(movements.length)
    last_movement = movements[rnd]
    @positions.update_board_details_after_black_move(last_movement)
    @positions.set_initial_board
    next_white_move
  end

  def give_current_board
    current_board = ""
    @positions.cells.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        current_board += cell[0...2]
        current_board += "," if (j < 7)
      end
      current_board += "*" if (i < 7)
    end
    current_board
  end

  def is_it_game_over(total_movements)
    if(total_movements==0)
      add_recent_board(total_movements)
      # start_game
      return true
    elsif(@positions.black_pieces.keys.length + @positions.white_pieces.keys.length == 2)
      # start_game
      return true
    end
    false
  end

  def add_recent_board(total_movements)
    bd = BoardData.new(give_current_board,
      @positions.black_pieces.keys.length,
      @positions.white_pieces.keys.length,
      @positions.black_long_castling,
      @positions.black_short_castling,
      @positions.white_long_castling,
      @positions.white_short_castling,
      last_movement_reduced,
      total_movements)
      @save_positions.save_position(bd) if(@save_in_database) 
      @boards.push(bd)
  end

  def last_movement_reduced
    @positions.last_movement.split(",",-1).map{|pos| pos[0...2]}.join(",")
  end

  def print_last_board_info
    puts "turn: #{(@boards.length+1)/2}"
    puts @boards.last.print_info
  end
end
