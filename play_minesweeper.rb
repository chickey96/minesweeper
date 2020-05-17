require './minesweeper_game.rb'

response = ""

# limited by numbers in the alphabet
def getValidNum(type)
  n = -1

  while (n < 1 || n > 26)
    puts "Enter the number of #{type} you want the board to have"
    puts "(1-26 or press enter for default)"
    n = gets.chomp
    # default to a 3x3 grid if user chooses not to select dimensions
    return 3 if n.length == 0
    # non-numeric input will become 0 and reprompt the user for valid input
    n = n.to_i
  end

  n
end

# ask user if they would like to play a game until receiving a valid response (y/Y/n/N)
while !["n", "y"].include?(response)
  puts "Would you like to start a game of Minesweeper? (y/n)"
  response = gets.chomp.downcase

  if response == "n"
    puts "goodbye"
  elsif response == "y"
    x = getValidNum("rows")
    y = getValidNum("cols")
    MinesweeperGame.new(x, y).playGame()
  else
    puts "Invalid response, please enter only y or n.\n"
  end
end
