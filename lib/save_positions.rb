require "pg"

class SavePositions
  def initialize
  end

  def save_position(board)
    begin
      con = PG.connect :host => "localhost", :port => 5432, :dbname => "chessmemo_db", :user => "postgres",
                       :password => "password"
      current_time = Time.now
      res = con.exec_params('insert into positions (pieces_position, total_black_pieces, total_white_pieces, black_long_castling, black_short_castling, white_long_castling, white_short_castling, last_movement, movements_available, next_player, created_at, updated_at) values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)', 
      [board.pieces_position, board.total_black_pieces, board.total_white_pieces, board.black_long_castling, board.black_short_castling, board.white_long_castling, board.white_short_castling, board.last_movement, board.movements_available, board.next_player, current_time, current_time])
      puts "res: #{res}"
    rescue PG::Error => e
      puts e.message
    ensure
      con.close if con
    end
  end
end
