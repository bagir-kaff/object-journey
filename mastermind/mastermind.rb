class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end
  
  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end
  
  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
end  
#optimal terminal height is more than 27
module Mastermind
  def clear_console
    system("clear")
  end
  class Game
    protected
    attr_accessor :game,:players,:code,:guess,:board,:length,:preferences

    public
    def initialize()
      @preferences = {duplicates?:true, code_length:4}
      puts "\npreferences"
      print "allow duplicates (yes or else): "
      preferences[:duplicates?] =  gets.chomp.downcase == "yes"
      print "code length (4,6,8): "
      preferences[:code_length] = gets.chomp.to_i
      return if preferences[:code_length] ==0
      @length = preferences[:code_length]
      @board = Array.new(13){[Array.new(length){" "},""]}
      puts
      puts "you are ....\nchoose:\n(1)secret code guesser\n(2)secret code creator\n(else)quit"
      choice = gets.chomp.to_i
      #[guesser, creator]
      if choice == 1 
        @players = {
          guesser:Human.new(length),
          creator:Computer.new(length,self)
        }
      elsif choice == 2
        @players = {
          guesser:Computer.new(length,self),
          creator:Human.new(length),
        }
      else
        @guess = "quit"
        return
      end
    end
    
    def play
      return if guess == "quit"
      attempts = 12
      puts "the code #{length}-digit number made out of numbers between 1 - 8,"
      @code = players[:creator].create_code(preferences[:duplicates?])
      while attempts>0 do
        puts " #{attempts} attempts left"
        print "#{players[:guesser]}'s guess: "
        @guess = players[:guesser].get_guess
        return if guess == "quit"
        self.players[:guesser].latest_response = check_guess(guess,code)
        self.board[attempts][0] = guess #an array ex:[5,4,2,5]
        self.board[attempts][1] = (players[:guesser].latest_response)
        print_board
        if guess == code
          puts "You figured out the code"
          return
        end
        attempts-=1
      end
      puts "the code is #{code}"
    end

    def print_board
      #clean it, would you?
      clear_console
      # puts "      ---MASTERMIND---"
      puts "╓─#{'─'*length*4}╥─#{'─'*length*2}┐"
      (1..12).reverse_each do |item|
        print"║ "
        length.times do |n|
          print "[#{board[item][0][n]}] "
        end
        puts "║#{to_colored(board[item][1],length)}│"
        # puts "║ [#{board[item][0][0]}] [#{board[item][0][1]}] [#{board[item][0][2]}] [#{board[item][0][3]}] ║#{to_colored(board[item][1])}│"
        puts "╠═#{'═'*length*4}╬═#{'═'*length*2}╡" if item > 1
        # why 4? 1 is for [, 2 is for coloredbutton,3 is for ], and 4 is for space
      end
      puts "╚═#{'═'*length*4}╩═#{'═'*length*2}╛"
    end

    def check_guess (temp_guess,temp_code)
      result=""
      temp_code = temp_code.dup
      temp_guess = temp_guess.dup
      #isolate same index and value
      temp_code = temp_code.map.with_index do |item,index| 
        if item==temp_guess[index]
          result+="O"
          temp_guess[index] = nil 
        else
          item
        end
      end
      #check same value only
      temp_code.each_with_index.reduce (result) do |result, (code_item , code_index)|
        material = nil
        if code_item
          temp_guess.each_with_index do | guess_item , guess_index|
            if guess_item
              if guess_item == code_item
                temp_guess[guess_index] = nil
                temp_code[code_index] = nil
                material = "X"
              end
            end
          end
        end
        if material
          result+=(material)
        else
          result
        end
      end
    end   

    def to_colored(result,code_length)
      str =""
      for i in 0..result.length-1
        item = result[i]
        if item == "O"
          str+= " \u25cf".red
        else
          str+= " \u25cf".gray
        end
      end
      str +=" "*(1+2*code_length-result.length*2)
    end 
  end

  class Human 
    attr_accessor :code_length,:game,:latest_response
    def initialize(code_length)
      @code_length = code_length
    end

    def get_guess
      tguess=""
      loop do
        tguess = gets.chomp.split("").map{|item| item.to_i}
        tguess.join
        return "quit" if tguess.join == "00000"
        break if tguess.length == code_length  && tguess.all?{|item| item>=1 && item<=8}
        puts "please put #{code_length} digit number made out of 1-8"
      end
      tguess
    end

    def to_s
      "mere Human"
    end
  end

class Computer
  attr_accessor :game,:code_length
  attr_reader :code
  def initialize(code_length,game)
    @code_length = code_length
    @game = game
  end
  def create_code(allow_duplicate)
    if allow_duplicate==true
      Array.new(code_length).map{|item| 1+Random.rand(8)}
    else
      [1,2,3,4,5,6,7,8].shuffle[0,code_length]
    end
  end
end
end 
 
include Mastermind
Game.new().play
puts "GAME OVER"
  # p check_guess(code,guess)
# things i just found out/remember
# 
# 1. each_index and each_with_index
  # its obvious
# 2.in #reduce and #each_with_index, what is the first parameter
# 2. reduce with index
# [1,2,3,4,5].each_with_index.reduce([]) do | result,(item,index)|
  # cool code here
# end