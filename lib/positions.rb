require "byebug"
require_relative "Cell"

class Positions
  def initialize
    @knight_movements = [
      Cell.new(1, 2),
      Cell.new(1, -2),
      Cell.new(2, 1),
      Cell.new(2, -1),
      Cell.new(-1, 2),
      Cell.new(-1, -2),
      Cell.new(-2, 1),
      Cell.new(-2, -1),
    ]

    @king_movements = [
      Cell.new(1, -1),
      Cell.new(1, 0),
      Cell.new(1, 1),
      Cell.new(0, -1),
      Cell.new(0, 1),
      Cell.new(-1, -1),
      Cell.new(-1, 0),
      Cell.new(-1, 1),
    ]

    @bishop_movements = [
      Cell.new(1, 1),
      Cell.new(1, -1),
      Cell.new(-1, 1),
      Cell.new(-1, -1),
    ]

    @rock_movements = [
      Cell.new(0, 1),
      Cell.new(0, -1),
      Cell.new(1, 0),
      Cell.new(-1, 0),
    ]

    @last_movement = ",,,,,,"
    @black_long_castling = true
    @lack_short_castling = true
    @white_long_castling = true
    @white_short_castling = true

    @next_black_queen = 2
    @next_black_rock = 3
    @next_black_bishop = 3
    @next_black_knight = 3
    @next_white_queen = 2
    @next_white_rock = 3
    @next_white_bishop = 3
    @next_white_knight = 3

    @cells = Array.new(8, Array.new(8, "").clone)
    @temp_cells = Array.new(8, Array.new(8, "").clone)

    @black_pieces = {
      "br1" => Cell.new(0, 0),
      "bn1" => Cell.new(0, 1),
      "bb1" => Cell.new(0, 2),
      "bq1" => Cell.new(0, 3),
      "bk" => Cell.new(0, 4),
      "bb2" => Cell.new(0, 5),
      "bn2" => Cell.new(0, 6),
      "br2" => Cell.new(0, 7),
      "bp1" => Cell.new(1, 0),
      "bp2" => Cell.new(1, 1),
      "bp3" => Cell.new(1, 2),
      "bp4" => Cell.new(1, 3),
      "bp5" => Cell.new(1, 4),
      "bp6" => Cell.new(1, 5),
      "bp7" => Cell.new(1, 6),
      "bp8" => Cell.new(1, 7),
    }
    @white_pieces = {
      "wp1" => Cell.new(0, 0),
      "wp2" => Cell.new(0, 1),
      "wp3" => Cell.new(0, 2),
      "wp4" => Cell.new(0, 3),
      "wp5" => Cell.new(0, 4),
      "wp6" => Cell.new(0, 5),
      "wp7" => Cell.new(0, 6),
      "wp8" => Cell.new(0, 7),
      "wr1" => Cell.new(1, 0),
      "wn1" => Cell.new(1, 1),
      "wb1" => Cell.new(1, 2),
      "wq1" => Cell.new(1, 3),
      "wk" => Cell.new(1, 4),
      "wb2" => Cell.new(1, 5),
      "wn2" => Cell.new(1, 6),
      "wr2" => Cell.new(1, 7),
    }
  end

  def white_king_attacked(king)
    return true if ((attacked_by_black_pawn(king.y, king.x)) || (attacked_by_black_knight(king.y, king.x)) || (attacked_by_black_king(king.y, king.x)) || (attacked_by_black_in_diagonals(king.y, king.x)) || (attacked_by_black_in_rowcolumns(king.y, king.x)))
    false
  end

  def black_king_attacked(king)
    return true if (attacked_by_white_pawn(king.y, king.x)) || (attacked_by_white_knight(king.y, king.x)) || (attacked_by_white_king(king.y, king.x)) || (attacked_by_white_in_diagonals(king.y, king.x)) || (attacked_by_white_in_rowcolumns(king.y, king.x))
    false
  end

  def available_black_moves
    moves = Hash.new
    moves.merge(available_black_king_moves)
    @black_pieces.each do |piece, position|
      if ("bn" =~ /^(bn)/) == 0
        moves.merge(available_black_knight_moves(piece, position))
      elsif ("bn" =~ /^(bb)/) == 0
        moves.merge(available_black_bishop_moves(piece, position))
      elsif ("bn" =~ /^(br)/) == 0
        moves.merge(available_black_rock_moves(piece, position))
      elsif ("bn" =~ /^(bq)/) == 0
        moves.merge(available_black_queen_moves(piece, position))
      elsif ("bn" =~ /^(bp)/) == 0
        moves.merge(available_black_pawn_moves(piece, position))
      end
    end
    moves
  end

  def available_black_king_moves()
    king = @black_pieces["bk"]
    available_movements = Hash.new
    @king_movements.each do |king_movement|
      n_cell = valid_position(king.y + king_movement.y, king.x + king_movement.x)
      if (n_cell == "" || n_cell =~ /^[w]/)
        @temp_cells = cells.clone()
        @temp_cells[king.y][king.x] = ""
        @temp_cells[king.y + king_movement.y][king.x + king_movement.x] = "bk"
        unless (black_king_attacked(Cell.new(king.y + king_movement.y, king.x + king_movement.x)))
          available_movements.Add("bk,#{king.y},#{king.x},bk,#{king.y + king_movement.y},#{king.x + king_movement.x},#{cells[king.y + king_movement.y][king.x + king_movement.x]}")
        end
      end
    end

    @temp_cells = cells.clone()
    if (black_long_castling && cells[0][1] == "" && cells[0][2] == "" && cells[0][3] == "" && !black_king_attacked(Cell.new(king.y, king.x)) && !black_king_attacked(Cell.new(king.y, king.x - 1)) && !black_king_attacked(Cell.new(king.y, king.x - 2)))
      available_movements.Add("bk,#{king.y},#{king.x},bk,#{king.y},#{king.x - 2},#{cells[king.y][king.x - 2]}")
    end
    if (black_short_castling && cells[0][5] == "" && cells[0][6] == "" && !black_king_attacked(Cell.new(king.y, king.x)) && !black_king_attacked(Cell.new(king.y, king.x + 1)) && !black_king_attacked(Cell.new(king.y, king.x + 2)))
      available_movements.Add("bk,#{king.y},#{king.x},bk,#{king.y},#{king.x + 2},#{cells[king.y][king.x + 2]}")
    end
    available_movements
  end

  ############################################################################
  def valid_position(y, x)
    return cells[y, x] if y >= 0 && y <= 7 && x >= 0 && x <= 7
    "v"
  end
end
