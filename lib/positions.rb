require "byebug"
class Positions
    def initialize
        @cells = Array.new(8, Array.new(8,"").clone)
        @king_movements = [
            {"x"=> 1, "y"=> -1},
            {"x"=> 1, "y"=> 0},
            {"x"=> 1, "y"=> 1},
            {"x"=> 0, "y"=> -1},
            {"x"=> 0, "y"=> 1},
            {"x"=> -1, "y"=> -1},
            {"x"=> -1, "y"=> 0},
            {"x"=> -1, "y"=> 1}
        ]
        @black_pieces = {
                "br1" => {"x"=> 0, "y"=> 0}, 
                "bn1" => {"x"=> 0, "y"=> 1}, 
                "bb1" => {"x"=> 0, "y"=> 2}, 
                "bq1" => {"x"=> 0, "y"=> 3}, 
                "bk" => {"x"=> 0, "y"=> 4}, 
                "bb2" => {"x"=> 0, "y"=> 5}, 
                "bn2" => {"x"=> 0, "y"=> 6}, 
                "br2" => {"x"=> 0, "y"=> 7}, 
                "bp1" => {"x"=> 1, "y"=> 0}, 
                "bp2" => {"x"=> 1, "y"=> 1}, 
                "bp3" => {"x"=> 1, "y"=> 2}, 
                "bp4" => {"x"=> 1, "y"=> 3}, 
                "bp5" => {"x"=> 1, "y"=> 4}, 
                "bp6" => {"x"=> 1, "y"=> 5}, 
                "bp7" => {"x"=> 1, "y"=> 6}, 
                "bp8" => {"x"=> 1, "y"=> 7}
            }
        @white_pieces = {
                "wp1" => {"x"=> 6, "y"=> 0}, 
                "wp2" => {"x"=> 6, "y"=> 1}, 
                "wp3" => {"x"=> 6, "y"=> 2}, 
                "wp4" => {"x"=> 6, "y"=> 3}, 
                "wp5" => {"x"=> 6, "y"=> 4}, 
                "wp6" => {"x"=> 6, "y"=> 5}, 
                "wp7" => {"x"=> 6, "y"=> 6}, 
                "wp8" => {"x"=> 6, "y"=> 7},
                "wr1" => {"x"=> 7, "y"=> 0}, 
                "wn1" => {"x"=> 7, "y"=> 1}, 
                "wb1" => {"x"=> 7, "y"=> 2}, 
                "wq1" => {"x"=> 7, "y"=> 3}, 
                "wk" => {"x"=> 7, "y"=> 4}, 
                "wb2" => {"x"=> 7, "y"=> 5}, 
                "wn2" => {"x"=> 7, "y"=> 6}, 
                "wr2" => {"x"=> 7, "y"=> 7}
            }
    end

    def update_board
        @cells = Array.new(8, Array.new(8,"").clone)
        add_pieces(@black_pieces)
        add_pieces(@white_pieces)
    end

    def add_pieces(pieces)
        pieces.each do |key, value|
            @cells[value["x"]][value["y"]]=key
        end
    end

    def king_moves(king)
        @king_movements.each do |m|
            x=@cells[king]["x"]+m["x"]
            y=@cells[king]["y"]+m["y"]
            new_cell = get_cell(x,y)
            if new_cell=="" || enemy_color?(king, new_cell)
                
            end
        end
    end

    def enemy_color?(piece1, piece2)
        color1=piece1.split("")[0]
        color2=piece1.split("")[0]
        return true if (color1=="w" && color2=="b") || (color1=="b" && color2=="w")
        false
    end

    def get_cell(x, y)
        return "-1" if (x>=0 && x<=7 && y>=0 && y<=7)
        @cells[x][y]
    end
end