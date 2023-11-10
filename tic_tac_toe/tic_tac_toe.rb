require "pry-byebug"
module Extra
  def number_to_column(n)
    (n / 3.1).to_i
  end  

  def number_to_row(n)
    (n - 1) % 3
  end

  def clear
    system('clear')
  end
end

class Game
include Extra

private

  attr_accessor :marks,:board,:current_player,:is_winner_exist,:again,:row_left

public

  def initialize
    @x_score = 0
    @o_score = 0
    self.board  = " 1 | 2 | 3 \n===+===+===\n 4 | 5 | 6 \n===+===+===\n 7 | 8 | 9 \n"
    self.marks = Array.new(3){Array.new(3," ")}
    self.row_left = (1..9).to_a
    self.again = "y"
    puts "TIC-TAC-TOE" 
  end

  def show_score
    "X = #{@x_score}\nO = #{@o_score}"
  end

  def start
    loop do
      puts "--> which one goes first? (O/X)"
      self.current_player = gets.chomp.upcase
      break if self.current_player == "X" || self.current_player == "O"
    end
    clear
    self.play
  end

  private

  def play
    while (self.again == "y") do
      puts self.board #print board
      9.times do
        #loop max 9 times or until fully marked
        while true do
          print "#{self.current_player}'s turn! choose row! #{self.row_left}:" #says hey player x or o, its your turn now
          choice = gets.chomp.to_i
          self.row_left.delete(choice)
          column_index = number_to_column(choice)
          row_index = number_to_row(choice)  
          break if (choice >= 1 && choice <= 9 && self.marks[column_index][row_index] == " ")
          p choice
          # if choice == 0 then return nil
        end
        clear
        puts fill_cell(column_index,row_index, self.current_player) # print board
        self.is_winner_exist = is_won?(column_index, row_index, self.current_player)
        shape = self.current_player
        self.current_player = (self.current_player == "X") ? "O" : "X"
        if self.is_winner_exist
          puts "#{shape} Won!!"
          if shape == "X"
            @x_score += 1
          else
             @o_score += 1
          end
          break
        end
      end 
      #loop nine times
      puts "its a  draw!" unless is_winner_exist
      puts show_score
      print "do you want to play again? (y,n): "
      self.again = gets.chomp.downcase
      clear
      self.row_left = (1..9).to_a
      self.marks = Array.new(3){Array.new(3," ")}
    end
  end

  def fill_cell(column,row, shape)
    self.marks[column][row] = shape
    board =" #{self.marks[0][0]} | #{self.marks[0][1]} | #{self.marks[0][2]} " +
    "\n===+===+===\n #{self.marks[1][0]} | #{self.marks[1][1]} | #{self.marks[1][2]} " +
    "\n===+===+===\n #{self.marks[2][0]} | #{self.marks[2][1]} | #{self.marks[2][2]} \n"
    #return board
  end

  def is_won?(column,row,shape)
    #check horizontaly and verticaly
    if self.marks[column].all?{|item| item == shape} then return true 
    elsif self.marks.all?{|item| item[row] == shape} then return true 
    #check diagonaly
    elsif self.marks[0][0] == shape && self.marks[1][1] == shape &&self.marks[2][2] == shape then return true 
    elsif self.marks[0][2] == shape && self.marks[1][1] == shape &&self.marks[2][0] == shape then return true 
    end
  end
end

my_game = Game.new
my_game.start
# binding.pry
puts "####END####"

/
current_player  = x or o 
board = literaly a tic tac toe board
marks = array of board marks
is_winner_exist = return true if exist
again = y or n for continuous playing
row_left = self explanotory
/
