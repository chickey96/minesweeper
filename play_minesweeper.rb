require './minesweeper_game.rb'

response = ""

def getValidNum(type)
  n = -1

  while (n < 1 || n > 26)
    puts "Enter the number of #{type} you want the board to have"
    puts "(1-26 or press enter for default)"
    n = gets.chomp.to_i
  end

  n
end

while !["n", "y"].include?(response)
  puts "would you like to start a game? (y/n)"
  response = gets.chomp.downcase

  if response == "n"
    puts "goodbye"
  elsif response == "y"
    x = getValidNum("rows")
    y = getValidNum("cols")
    MinesweeperGame.new(x, y).playGame()
  else
    puts "Invalid response, please enter only y or n."
  end
end
