class Minesweeper
  def initialize()
    @board = [['X','X','X'],['X','X','X'],['X','X','X']]
    @data_hash = generateDataHash()
    @game_over = false
    @uncovered = 0
    @labels_hash = {'A'=> 0, 'B'=> 1, 'C'=> 2}
    @labels = @labels_hash.keys
    @invalid_msg = "\nINVALID INPUT!!!"
    @try_again = "Try Again!\n"
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

    repeated_spot = spotAlreadySelected?(x, y)

    while (repeated_spot)
      printBoard()
      x, y = askPlayerForTurn()
      repeated_spot = spotAlreadySelected?(x, y)
    end

    @board[x][y] = @data_hash[[x,y]] || 0
    @uncovered += 1 if (@board[x][y] != -1)

    @game_over = true if (@board[x][y] == -1 || @uncovered == 7)
  end

  def finishGame()
    printBoard()
    puts (@uncovered == 7 ? "\nYOU WON!" : "\nKABOOOM! YOU LOST!")
  end

  def printBoard()
    puts "\n  #{@labels.join(" ")}"
    @board.each_with_index { |row, i| puts @labels[i].to_s + " " + row.join(" ") }
    print "\n"
  end

  def askPlayerForTurn()
    print "Choose a square!\n"
    x = askPlayerFor("Row")
    y = askPlayerFor("Column")
    [x, y]
  end

  def askPlayerFor(type)
    response = promptTurn(type)
    response_num = @labels_hash[response.upcase]
    validity_status = isValidInput?(response_num)

    # continue prompting until player gives valid input
    until (validity_status)
      printBoard()
      response = promptTurn(type).upcase
      response_num = @labels_hash[response]
      validity_status = isValidInput?(response_num)
    end

    response_num
  end

  def promptTurn(type)
    print "#{type}: "
    gets.chomp
  end

  # output specific messages to give player feedback on invalid input
  def isValidInput?(input_num)
    return true if isValid?(input_num)

    msg = "Valid input is a letter #{@labels[0]}-#{@labels[@labels.length-1]}."
    printInvalidSelectionMessage(msg)

    false
  end

  def spotAlreadySelected?(x, y)
    return false if @board[x][y] == "X"

    printInvalidSelectionMessage("That space has already been selected.")

    true
  end

  def printInvalidSelectionMessage(custom_msg)
    puts (@invalid_msg + custom_msg)
    puts @try_again
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

      if isValid?(pos_x) && isValid?(pos_y)
        contacts[[pos_x, pos_y]] = 1
      end
    end

    contacts
  end

  def isValid?(n)
    return false if (!n || n > 2 || n < 0)
    true
  end
end