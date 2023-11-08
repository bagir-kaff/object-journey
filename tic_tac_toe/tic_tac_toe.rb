class Game
  # private
  
  attr_accessor :marks, :board, :current

  # public

  def initialize
    @marks = Array.new(3){Array.new(3," ")}
    @board = " 1 | 2 | 3 \n===+===+===\n 4 | 5 | 6 \n===+===+===\n 7 | 8 | 9 \n"
    puts "TIC TAC TOE"
  end
  def start
    loop do
      puts "--> which one goes first? (O/X)"
      self.current = gets.chomp.upcase
      break if self.current == "X" || self.current  == "O"
    end
  end
end

# mine= Game.new
# p mine.start