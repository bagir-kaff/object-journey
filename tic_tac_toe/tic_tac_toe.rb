class Game
  # private
  
  attr_accessor :marks, :board

  # public

  def initialize
    @marks = Array.new(3){Array.new(3," ")}
    @board = " 1 | 2 | 3 \n===+===+===\n 4 | 5 | 6 \n===+===+===\n 7 | 8 | 9 \n"
  end
end