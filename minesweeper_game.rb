require './board.rb'

class MinesweeperGame
  def initialize(r=3, c=3)
    @board = Board.new(r, c)
    @game_over = false
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

    if (@board.exploded)
      puts "\nKABOOOM! YOU LOST!"
      @board.printExposedBoard()
    else
      @game_over = false
      @board = Board.new(@board.rows+1, @board.cols+1)
      playGame()
    end
  end

  def askPlayerForTurn()
    print "Choose a square!\n"
    x = askPlayerFor("Row")
    y = askPlayerFor("Column")

    [x, y]
  end

  def askPlayerFor(type)
    raw_response = promptTurn(type)
    processed = @board.getIndexFromLabel(raw_response, type)

    # continue prompting until player gives valid input
    until (@board.inputInBounds?(processed, type))
      @board.printBoard()
      raw_response = promptTurn(type)
      processed = @board.getIndexFromLabel(raw_response, type)
    end

    processed
  end

  def promptTurn(type)
    print "#{type}: "
    gets.chomp
  end
end