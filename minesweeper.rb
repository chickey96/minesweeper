class Minesweeper
  def initialize()
    @board = [['X','X','X'],['X','X','X'],['X','X','X']]
    @data_hash = generateDataHash()
    @game_over = false
    @uncovered = 0
  end

  def playGame()
    until @game_over
      playTurn()
    end

    finishGame()
  end

  def playTurn()
    printBoard()
    x, y = askPlayerForTurn()

    @board[x][y] = @data_hash[[x,y]] || 0
    @uncovered += 1 if (@board[x][y] != -1)

    @game_over = true if (@board[x][y] == -1 || @uncovered == 7)
  end

  def finishGame()
    printBoard()
    puts (@uncovered == 7 ? "\nYOU WON!" : "\nKABOOOM! YOU LOST!")
  end

  def printBoard()
    puts "\n  0 1 2 "
    @board.each_with_index { |r, i| puts i.to_s + " " + r.join(" ") }
  end

  def askPlayerForTurn()
    x, y = promptTurn()
    validity_status = inputValidityCheck(x, y)

    # continue prompting until player gives valid input
    until (validity_status == "true")
      puts validity_status
      x, y = promptTurn()
      validity_status = inputValidityCheck(x, y)
    end

    [x.to_i, y.to_i]
  end

  def promptTurn()
    print "\nChoose a square! \nRow number (0-2): "
    x = gets.chomp
    print "Column number (0-2):"
    y = gets.chomp

    [x, y]
  end

  # output specific messages to give player feedback on invalid input
  def inputValidityCheck(x, y)
    if blankOrNonDigit?(x) || blankOrNonDigit?(y) || !isValid?(x.to_i, y.to_i)
      return "\nValid input is a number 0-2.\n(See the top row and leftmost column for reference)"
    elsif @board[x.to_i][y.to_i] != "X"
      return "\nThat space has already been selected. Choose again."
    end

    "true"
  end

  # screen for non_digit chars and empty strings
  def blankOrNonDigit?(n)
    return true if n.length < 1 || (n.to_i == 0 && n != "0")
    false
  end

  # game setup methods
  def generateDataHash()
    bomb_1 = [rand(3), rand(3)]
    bomb_2 = [rand(3), rand(3)]

    # don't allow duplicate bomb coordinates
    while (bomb_2 == bomb_1)
      bomb_2 = [rand(3), rand(3)]
    end

    hash = adjacentData(bomb_1)
    hash_2 = adjacentData(bomb_2)

    # add the number of bombs each square is touching
    hash.merge!(hash_2) do |key, old_val, new_val|
      (old_val + new_val)
    end

    # note the location of the bombs
    hash[bomb_2] = -1
    hash[bomb_1] = -1

    hash
  end

  # record in-bounds squares touching the given bomb
  def adjacentData(pos)
    x,y = pos
    contacts = {}

    positions = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]

    positions.each do |pos_x, pos_y|
      pos_x += x
      pos_y += y

      contacts[[pos_x, pos_y]] = 1 if isValid?(pos_x, pos_y)
    end

    contacts
  end

  def isValid?(x, y)
    return false if (x > 2 || x < 0 || y > 2 || y < 0)
    true
  end
end