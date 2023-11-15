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
    @board  = " 1 | 2 | 3 \n===+===+===\n 4 | 5 | 6 \n===+===+===\n 7 | 8 | 9 \n"
    @marks = Array.new(3){Array.new(3," ")}
    @row_left = (1..9).to_a
    @again = "y"
    puts "TIC-TAC-TOE" 
  end

  def show_score
    "X = #{@x_score}\nO = #{@o_score}"
  end

  def start
    loop do
      puts "--> which one goes first? (O/X)"
      self.current_player = gets.chomp.upcase
      break if current_player == "X" || current_player == "O"
    end
    play
  end

  private

  def play
    while (again == "y") do
      clear
      puts board #print board
      9.times do
        #loop max 9 times or until fully marked
        while true do
          print "#{current_player}'s turn! choose position! #{row_left}:" #says hey player x or o, its your turn now
          choice = gets.chomp.to_i
          row_left.delete(choice)
          column_index = number_to_column(choice)
          row_index = number_to_row(choice)  
          break if (choice >= 1 && choice <= 9 && marks[column_index][row_index] == " ")
          puts "position #{choice} is not available, try again"
          # if choice == 0 then return nil
        end
        clear
        puts fill_cell(column_index,row_index, current_player) # print board
        self.is_winner_exist = is_won?(column_index, row_index, current_player)
        if is_winner_exist
          puts "#{current_player} Won!!"
          if current_player == "X"
            @x_score += 1
          else
             @o_score += 1
          end
          break
        elsif board_full?
          puts "its a draw!"
        end
        self.current_player = (current_player == "X") ? "O" : "X"
      end 
      #loop nine times
      puts show_score
      print "do you want to play again? (y,n): "
      self.again = gets.chomp.downcase
      self.row_left = (1..9).to_a
      self.marks = Array.new(3){Array.new(3," ")}
    end
  end

  def fill_cell(column,row, shape)
    marks[column][row] = shape
    board =" #{marks[0][0]} | #{marks[0][1]} | #{marks[0][2]} " +
    "\n===+===+===\n #{marks[1][0]} | #{marks[1][1]} | #{marks[1][2]} " +
    "\n===+===+===\n #{marks[2][0]} | #{marks[2][1]} | #{marks[2][2]} \n"
    #return board
  end

  def is_won?(column,row,shape)
    #check horizontaly and verticaly
    if marks[column].all?{|item| item == shape} then return true 
    elsif marks.all?{|item| item[row] == shape} then return true 
    #check diagonaly
    elsif marks[0][0] == shape && marks[1][1] == shape &&marks[2][2] == shape then return true 
    elsif marks[0][2] == shape && marks[1][1] == shape &&marks[2][0] == shape then return true 
    end
  end
  def board_full?
    row_left.empty?
  end
end

Game.new.start
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
