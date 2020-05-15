require './minesweeper.rb'

response = ""

while !["n", "y"].include?(response)
  puts "would you like to start a game? (y/n)"
  response = gets.chomp.downcase

  if response == "n"
    puts "goodbye"
  elsif response == "y"
    Minesweeper.new().playGame()
  else
    puts "Invalid response, please enter only y or n."
  end
end