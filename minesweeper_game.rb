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
    @board.printBoardWithOptionalExposure()
    x, y = askPlayerForTurn()

    while (@board.spotAlreadyUncovered?(x, y))
      @board.printBoardWithOptionalExposure()
      x, y = askPlayerForTurn()
    end

    @board.uncoverSpot(x, y)
    @game_over = @board.boardFilledOrExploded?()
  end

  def finishGame()
    print "\n"

    if (@board.exploded)
      print "KABOOOM!!!".colorize(:color => :red).bold
      print "YOU LOST!".colorize(:background => :light_red, :color => :black).bold
    else
      print "YOU WON!!!".colorize(:background => :light_yellow, :color => :black).bold
    end

    @board.printBoardWithOptionalExposure(true)

    return if @board.exploded

    startNextLevel()
  end

  # reset the game and start gameplay increasing board dimensions by 1
  def startNextLevel
    @game_over = false
    @board = Board.new(@board.rows+1, @board.cols+1)
    print "LEVEL UP!".colorize(:background => :light_green, :color => :black).bold

    playGame()
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
      @board.printBoardWithOptionalExposure()
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