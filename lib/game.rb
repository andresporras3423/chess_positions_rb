require_relative 'Positions'

class Game
    def initialize(save)
      @save = save
      @positions = Positions.new
      @save = false
    end

    def start()
        @positions.update_board
        next_move
    end

    def next_move()
      
    end
end