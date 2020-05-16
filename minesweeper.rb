require './board.rb'

class Minesweeper
  def initialize()
    @board = Board.new(self, 3, 3)
    @game_over = false
    @invalid_msg = "\nINVALID INPUT!!!"
    @try_again = "Try Again!\n"
  end

  def playGame()
    playTurn() until @game_over

    finishGame()
  end

  def playTurn()
    @board.printBoard()
    x, y = askPlayerForTurn()

    while (@board.spotAlreadySelected?(x, y))
      @board.printBoard()
      x, y = askPlayerForTurn()
    end

    @board.uncoverSpot(x, y)

    @game_over = @board.boardFilledOrExploded?()
  end

  def finishGame()
    @board.printBoard()

    puts (@board.exploded ? "\nKABOOOM! YOU LOST!" : "\nYOU WON!")
  end

  def askPlayerForTurn()
    print "Choose a square!\n"
    x = askPlayerFor("Row")
    y = askPlayerFor("Column")

    [x, y]
  end

  def askPlayerFor(type)
    response = promptTurn(type).upcase
    response_num = @board.getIndexFromLabel(response)

    # continue prompting until player gives valid input
    until (isValidInput?(response_num, type))
      @board.printBoard()
      response = promptTurn(type).upcase
      response_num = @board.getIndexFromLabel(response)
    end

    response_num
  end

  def promptTurn(type)
    print "#{type}: "
    gets.chomp
  end

  # output specific messages to give player feedback on invalid input
  def isValidInput?(input_num, type)
    return true if isValid?(input_num)

    msg = "Valid input is a letter A-#{@board.labelOptionsFor(type)}."
    printInvalidSelectionMessage(msg)

    false
  end

  def printInvalidSelectionMessage(custom_msg)
    puts (@invalid_msg + custom_msg)
    puts @try_again
  end

  def isValid?(n)
    return false if (!n || n > 2 || n < 0)
    true
  end
end