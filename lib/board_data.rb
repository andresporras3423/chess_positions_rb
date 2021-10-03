require "byebug"

class BoardData

  attr_accessor :pieces_position, :total_black_pieces, :total_white_pieces, :black_long_castling,
  :black_short_castling, :white_long_castling, :white_short_castling, :last_movement, :movements_available

  def initialize(pieces_position_, total_black_pieces_, total_white_pieces_, black_long_castling_, 
                 black_short_castling_, white_long_castling_, white_short_castling_, last_movement_, movements_available_)
    @pieces_position=pieces_position_
    @total_black_pieces=total_black_pieces_
    @total_white_pieces=total_white_pieces_
    @black_long_castling=black_long_castling_
    @black_short_castling=black_short_castling_
    @white_long_castling=white_long_castling_
    @white_short_castling=white_short_castling_
    @last_movement=last_movement_
    @movements_available=movements_available_
  end 

  def print_info
    """
    current board: #{@pieces_position}
    total black pieces: #{@otal_black_pieces}
    total white pieces: #{@total_white_pieces}
    total pieces: #{@total_black_pieces+@total_white_pieces}
    black long castling: #{@black_long_castling}
    black short castling: #{@black_short_castling}
    white long castling: #{@white_long_castling}
    white short castling: #{@white_short_castling}
    most recent movement: #{@last_movement}
    total movements available: #{@movements_available}
    """
  end
end