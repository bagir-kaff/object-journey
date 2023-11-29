# Object Journey
ruby object oriented basic projects, its tic-tac-toe and mastermind command line game (link be provided soon),<br>
[a better ruby example.](https://rosettacode.org/wiki/Tic-tac-toe#Ruby)
1. its fine to write ClassName.new.method if not needed
``` ruby
#before
my_game = Game.new
my_game.start

#after
Game.new.start
```

2. some instance method i wrote doesnt need self
```ruby
..
#before
def play
    while (self.again == "y") do
      puts self.board
      9.times do
        while true do
          print "#{self.current_player}'s turn! choose row! #{row_left}:"         
..
#after
def play
    while (again == "y") do
      puts board
      9.times do
        while true do
          print "#{current_player}'s turn! choose row! #{row_left}:"         
```
<dt>other small changes</dt>
<dd>removed excesive clear method</dd>
<dd>keep the board and score after playing</dd>
<dd>wrote p choice, cant remember why,<br>--fixed it to puts "position #{choice} is not available, try again"</dd>
<dd>from choose row to choose position</dd>
<dd>removed shape variable because it is the same as current player</dd>
<dd>added board_full? method</dd>
<dd></dd>
<dd></dd>