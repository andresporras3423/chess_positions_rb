require_relative 'Positions'

class Game
    def initialize(save)
      @save = save
      @positions = Positions.new
      @save = false
    end

    def start()
        @positions.update_board
    end
end