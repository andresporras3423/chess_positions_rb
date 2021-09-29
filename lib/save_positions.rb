class SavePositions
  def save_position(board)
    begin
      con = PG.connect :host => "localhost", :port => 5432, :dbname => "chessmemo_db", :user => "postgres",
                       :password => "password"
      res = conn.exec_params('insert into positions (pieces_position, total_black_pieces, total_white_pieces, black_long_castling, black_short_castling, white_long_castling, white_short_castling, last_movement, movements_available) values ($1, $2, $3, $4, $5, $6, $7)', 
      [board.pieces_position, board.total_black_pieces, board.total_white_pieces, board.black_long_castling, board.black_short_castling, board.white_long_castling, board.white_short_castling, board.last_movement, board.movements_available])
      # user = con.user
      # db_name = con.db
      # pswd = con.pass
      # puts "User: #{user}"
      # puts "Database name: #{db_name}"
      # puts "Password: #{pswd}"
      puts "res: #{res}"
    rescue PG::Error => e
      puts e.message
    ensure
      con.close if con
    end
  end

  # public static class SavePositions
  #     {
  #         public static void savePosition(BoardData nboard)
  #         {
  #             try
  #             {
  #                 using (var context = new chessmemoContext())
  #                 {
  #                     Position nPosition = new Position{Board=nboard.pieces_position,
  #                         TotalBlackPieces=nboard.total_black_pieces,
  #                         TotalWhitePieces = nboard.total_white_pieces,
  #                         BlackLongCastling =nboard.black_long_castling,
  #                         BlackShortCastling=nboard.black_short_castling,
  #                         WhiteLongCastling=nboard.white_long_castling,
  #                         WhiteShortCastling=nboard.white_short_castling,
  #                         LastMove=nboard.last_movement,
  #                         AvailableMoves=nboard.movements_available };
  #                         context.Add(nPosition);
  #                         context.SaveChanges();
  #                 };
  #             }
  #             catch (Exception ex)
  #             {
  #                 Console.WriteLine("An error has occurred in the database: ");
  #                 Console.WriteLine(ex);
  #             }
  #         }
  #     }
end
