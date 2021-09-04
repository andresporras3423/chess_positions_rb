class Positions
    def initialize
        @cells = Array.new(8, Array.new(8,"").clone)
        @black_pieces = Hash.new(
            {
                "br1" => Hash.new("x": 0, "y": 0), 
                "bn1" => Hash.new("x": 0, "y": 1), 
                "bb1" => Hash.new("x": 0, "y": 2), 
                "bq1" => Hash.new("x": 0, "y": 3), 
                "bk" => Hash.new("x": 0, "y": 4), 
                "bb2" => Hash.new("x": 0, "y": 5), 
                "bn2" => Hash.new("x": 0, "y": 6), 
                "br2" => Hash.new("x": 0, "y": 7), 
                "bp1" => Hash.new("x": 1, "y": 0), 
                "bp2" => Hash.new("x": 1, "y": 1), 
                "bp3" => Hash.new("x": 1, "y": 2), 
                "bp4" => Hash.new("x": 1, "y": 3), 
                "bp5" => Hash.new("x": 1, "y": 4), 
                "bp6" => Hash.new("x": 1, "y": 5), 
                "bp7" => Hash.new("x": 1, "y": 6), 
                "bp8" => Hash.new("x": 1, "y": 7)
            }
        )
        @white_pieces = Hash.new(
            {
                "wp1" => Hash.new("x": 6, "y": 0), 
                "wp2" => Hash.new("x": 6, "y": 1), 
                "wp3" => Hash.new("x": 6, "y": 2), 
                "wp4" => Hash.new("x": 6, "y": 3), 
                "wp5" => Hash.new("x": 6, "y": 4), 
                "wp6" => Hash.new("x": 6, "y": 5), 
                "wp7" => Hash.new("x": 6, "y": 6), 
                "wp8" => Hash.new("x": 6, "y": 7),
                "wr1" => Hash.new("x": 7, "y": 0), 
                "wn1" => Hash.new("x": 7, "y": 1), 
                "wb1" => Hash.new("x": 7, "y": 2), 
                "wq1" => Hash.new("x": 7, "y": 3), 
                "wk" => Hash.new("x": 7, "y": 4), 
                "wb2" => Hash.new("x": 7, "y": 5), 
                "wn2" => Hash.new("x": 7, "y": 6), 
                "wr2" => Hash.new("x": 7, "y": 7)
            }
        )
    end

    def update_board
        @cells = Array.new(8, Array.new(8,"").clone)
    end
end