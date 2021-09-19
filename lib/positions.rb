require "byebug"
require 'set'
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
    moves = Set.new
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
    available_movements = Set.new
    @king_movements.each do |king_movement|
      n_cell = valid_position(king.y + king_movement.y, king.x + king_movement.x)
      if (n_cell == "" || n_cell =~ /^[w]/)
        @temp_cells = cells.clone()
        @temp_cells[king.y][king.x] = ""
        @temp_cells[king.y + king_movement.y][king.x + king_movement.x] = "bk"
        unless (black_king_attacked(Cell.new(king.y + king_movement.y, king.x + king_movement.x)))
          available_movements.add("bk,#{king.y},#{king.x},bk,#{king.y + king_movement.y},#{king.x + king_movement.x},#{cells[king.y + king_movement.y][king.x + king_movement.x]}")
        end
      end
    end

    @temp_cells = cells.clone()
    if (@black_long_castling && @cells[0][1] == "" && @cells[0][2] == "" && @cells[0][3] == "" && !black_king_attacked(Cell.new(king.y, king.x)) && !black_king_attacked(Cell.new(king.y, king.x - 1)) && !black_king_attacked(Cell.new(king.y, king.x - 2)))
      available_movements.add("bk,#{king.y},#{king.x},bk,#{king.y},#{king.x - 2},#{cells[king.y][king.x - 2]}")
    end
    if (@black_short_castling && @cells[0][5] == "" && @cells[0][6] == "" && !black_king_attacked(Cell.new(king.y, king.x)) && !black_king_attacked(Cell.new(king.y, king.x + 1)) && !black_king_attacked(Cell.new(king.y, king.x + 2)))
      available_movements.add("bk,#{king.y},#{king.x},bk,#{king.y},#{king.x + 2},#{cells[king.y][king.x + 2]}")
    end
    available_movements
  end

  def available_black_knight_moves(piece, knight)
    king = @black_pieces["bk"]
    available_movements = Set.new
    knight_movements.each do |knight_movement|
      cell_ = valid_position(knight.y + knight_movement.y, knight.x + knight_movement.x)
      if (cell_ == "" || cell_[0] == "w")
        @temp_cells = @cells.clone
        @temp_cells[knight.y][knight.x] = ""
        @temp_cells[knight.y + knight_movement.y][knight.x + knight_movement.x] = @cells[knight.x][knight.y]
        unless (black_king_attacked(Cell.new(king.y, king.x)))
          available_movements.add("#{piece},#{knight.y},#{knight.x},#{piece},#{knight.y + knight_movements.y},#{knight.x + knight_movements.x},#{cells[knight.y + knight_movements.y, knight.x + knight_movements.x]}")
        end
      end
    end
    available_movements
  end

  def available_black_pawn_moves(piece, pawn)
    king = @blackPieces["bk"]
    available_movements = Set.new
    cell_ = valid_position(pawn.y, pawn.x)
    if(cell_=="")
      @temp_cells = @cells.clone()
      @temp_cells[pawn.y, pawn.x] = ""
      @temp_cells[pawn.y + 1][pawn.x] = @cells[pawn.y][pawn.x]
      unless(black_king_attacked(Cell.new(king.y, king.x)))
        if(pawn.y+1<7) then available_movements.add("#{piece},#{pawn.y},#{pawn.x},#{piece},#{pawn.y + 1},#{pawn.x},")
        else available_promotion_moves(piece, pawn.y, pawn.x, pawn.y + 1, pawn.x, available_movements)
      end
    end
    if(pawn.y==1)
      cell_ = valid_position(pawn.y+1, pawn.x)
      cell2_ = valid_position(pawn.y+2, pawn.x)
      if(cell_=="" && cell2_=="")
        @temp_cells = @cells.clone
        @temp_cells[pawn.y][pawn.x]=""
        @temp_cells[pawn.y+2][pawn.x] = @cells[pawn.y][pawn.x]
        availableMovements.Add("#{piece},#{pawn.y},#{pawn.x},#{piece},#{pawn.y + 2},#{pawn.x},") unless black_king_attacked(Cell.new(king.y, king.x))
      end
    end
    cell_ = valid_position(pawn.y+1, pawn.x+1)
    if(cell_[0]=="w")
      @temp_cells = @cells.clone
      @temp_cells[pawn.y][pawn.x] = ""
      @tempCells[pawn.y + 1][pawn.x + 1] = @cells[pawn.y][pawn.x]
      unless(black_king_attacked(Cell.new(king.y, king.x)))
        if(pawn.y+1<7) then available_movements.add("#{piece},#{pawn.y},#{pawn.x},#{piece},#{pawn.y + 1},#{pawn.x + 1},#{@cells[pawn.y + 1][pawn.x + 1]}")
        else available_promotion_moves(piece, pawn.y, pawn.x, pawn.y + 1, pawn.x + 1, available_movements) end
      end
    end

    cell_ = valid_position(pawn.y+1, pawn.x-1)
    if(cell_[0]=="w")
      @temp_cells = @cells.clone
      @temp_cells[pawn.y][pawn.x] = ""
      @temp_cells[pawn.y+1][parn.x-1] = @cells[pawn.y][pawn.x]
      unless black_king_attacked(Cell.new(king.y, king.x))
        if(pawn.y+1<7) then available_movements.add("#{piece},#{pawn.y},#{pawn.x},#{piece},#{pawn.y + 1},#{pawn.x - 1},#{@cells[pawn.y + 1][pawn.x - 1]}")
        else available_promotion_moves(piece, pawn.y, pawn.x, pawn.y + 1, pawn.x - 1, available_movements) end
      end
    end

    if(can_black_en_passant(pawn.y, pawn.x + 1))
      @temp_cells = @cells.clone
      @temp_cells[pawn.y][pawn.x] = ""
      @temp_cells[pawn.y][pawn.x+1] = ""
      @temp_cells[pawn.y+1][pawn.x+1]=@cells[pawn.y][pawn.x]
      available_movements.add("#{piece},#{pawn.y},#{pawn.x},#{piece},#{pawn.y + 1},#{pawn.x + 1},#{@cells[pawn.y][pawn.x + 1]}") unless black_king_attacked(Cell.new(king.y, king.x))
    end

    if(can_black_en_passant(pawn.y, pawn.x - 1))
      @temp_cells = @cells.clone
      @temp_cells[pawn.y][pawn.x] = ""
      @temp_cells[pawn.y][pawn.x-1] = ""
      @temp_cells[pawn.y+1][pawn.x-1]=@cells[pawn.y][pawn.x]
      available_movements.add("#{piece},#{pawn.y},#{pawn.x},#{piece},#{pawn.y + 1},#{pawn.x - 1},#{@cells[pawn.y][pawn.x - 1]}") unless black_king_attacked(Cell.new(king.y, king.x))
    end
  end

  def can_black_en_passant(y, x)
    move_details = @last_movement.split(",")
    if (move_details[0]=~/^w/ &&
                    move_details[1].to_i == y + 2 &&
                    move_details[2].to_i == x &&
                    move_details[3]=~/^w/ &&
                    move_details[4].to_i == y &&
                    move_details[5].to_i == x &&
                    move_details[6] == "")
                    return true
    end
    false
  end

  def can_black_en_passant(y, x)
    move_details = @last_movement.split(",")
    if (move_details[0]=~/^b/ &&
                    move_details[1].to_i == y - 2 &&
                    move_details[2].to_i == x &&
                    move_details[3]=~/^b/ &&
                    move_details[4].to_i == y &&
                    move_details[5].to_i == x &&
                    move_details[6] == "")
                    return true
    end
    false
  end

  def available_black_bishop_moves(piece, bishop)
    king = @black_pieces["bk"]
    available_movements = Set.new
    @bishop_movements.each do |bishop_movement|
      position_ = Cell.new(bishop.y, bishop.x)
      loop do
        position_.x += bishop_movement.x
        position_.y += bishop_movement.y
        cell_=valid_position(position_.y, position_.x)
        if(cell_=="" || cell_=~/^w/)
          @temp_cells = @cells.clone
          @temp_cells = ""
          @temp_cells[position_.y][position_.x] = @cells[bishop.y][bishop.x]
          unless black_king_attacked(Cell.new(king.y, king.x))
            available_movements.add("#{piece},#{bishop.y},#{bishop.x},#{piece},#{position_.y},#{position_.x},#{@cells[position_.y][position_.x]}")
          end
        end
        break if(cell_!="")
      end
    end
    available_movements
  end

  def available_black_rock_moves(piece, rock)
    king = @black_pieces["bk"]
    available_movements = Set.new
    @rock_movements.each do |rock_movement|
      position_ = Cell.new(rock.y, rock.x)
      loop do
        position_.x+=rock_movement.x
        position_.y += rock_movement.y 
        cell_ = valid_position(position_.y, position_.x)
        if(cell_=="" || cell_=~/^w/)
          @temp_cells = @cells.clone
          @temp_cells[rock.y][rock.x] = ""
          @temp_cells[position_.y][position_.x] = @cells[rock.y, rock.x]
          unless black_king_attacked(Cell.new(king.y, king.x))
            available_movements.add("#{piece},#{rock.y},#{rock.x},#{piece},#{position_.y},#{position_.x},#{@cells[position_.y, position_.x]}")
          end
        end
        break if (cell_!="")
      end
    end
    available_movements
  end

  # public HashSet<string> available_black_queen_moves(string piece, Cell queen)
  # {
  #     Cell king = blackPieces["bk"];
  #     HashSet<string> availableMovements = new HashSet<string>();
  #     foreach (var rockMovement in rockMovements)
  #     {
  #         Cell nPosition = new Cell(queen.y, queen.x);
  #         while (true)
  #         {
  #             nPosition.x += rockMovement.x;
  #             nPosition.y += rockMovement.y;
  #             string nCell = valid_position(nPosition.y, nPosition.x);
  #             if (nCell == "" || Regex.Match(nCell, @"^w").Success)
  #             {
  #                 tempCells = (string[,])cells.Clone();
  #                 tempCells[queen.y, queen.x] = "";
  #                 tempCells[nPosition.y, nPosition.x] = cells[queen.y, queen.x];
  #                 if (!black_king_attacked(new Cell(king.y, king.x)))
  #                 {
  #                     availableMovements.Add($"{piece},{queen.y},{queen.x},{piece},{nPosition.y},{nPosition.x},{cells[nPosition.y, nPosition.x]}");
  #                 }
  #             }
  #             if (nCell != "") break;
  #         }
  #     }
  #     foreach (var bishopMovement in bishopMovements)
  #     {
  #         Cell nPosition = new Cell(queen.y, queen.x);
  #         while (true)
  #         {
  #             nPosition.x += bishopMovement.x;
  #             nPosition.y += bishopMovement.y;
  #             string nCell = valid_position(nPosition.y, nPosition.x);
  #             if (nCell == "" || Regex.Match(nCell, @"^w").Success)
  #             {
  #                 tempCells = (string[,])cells.Clone();
  #                 tempCells[queen.y, queen.x] = "";
  #                 tempCells[nPosition.y, nPosition.x] = cells[queen.y, queen.x];
  #                 if (!black_king_attacked(new Cell(king.y, king.x)))
  #                 {
  #                     availableMovements.Add($"{piece},{queen.y},{queen.x},{piece},{nPosition.y},{nPosition.x},{cells[nPosition.y, nPosition.x]}");
  #                 }
  #             }
  #             if (nCell != "") break;
  #         }
  #     }
  #     return availableMovements;
  # }
  ############################################################################
  def valid_position(y, x)
    return @cells[y][x] if y >= 0 && y <= 7 && x >= 0 && x <= 7
    "v"
  end
end
