class RulesAndSetup
  def initialize(board)
    @board = board
    @invalid_msg = "\nINVALID INPUT!!!"
    @try_again = "Try Again!\n"
  end

  def printInvalidSelectionMessage(custom_msg)
    puts (@invalid_msg + custom_msg)
    puts @try_again
  end

  def isValid?(n, type)
    max = (type == 'Row') ? @board.rows : @board.cols
    return false if (!n || n >= max || n < 0)
    true
  end

  # output specific messages to give player feedback on invalid input
  def isValidInput?(input_num, type)
    return true if isValid?(input_num, type)

    msg = "Valid input is a letter A-#{@board.labelOptionsFor(type)}."
    printInvalidSelectionMessage(msg)

    false
  end

  def generateBoard()
    board = []

    (1..@board.rows).each do |r|
      row = []
      (1..@board.cols).each { |c| row.push('X') }
      board.push(row)
    end

    board
  end

  # game setup methods
  def generateDataHash()
    n_bombs = Math.sqrt(@board.rows * @board.cols).to_i - 1
    existing_bombs = {}
    bomb = [rand(@board.rows), rand(@board.cols)]
    existing_bombs[bomb] = "B"
    bomb_count = 1

    data_hash = adjacentData(bomb)

    while (bomb_count < n_bombs)
      # don't allow duplicate bomb coordinates
      while (existing_bombs[bomb])
        bomb = [rand(@board.rows), rand(@board.cols)]
      end

      # now have found a new bomb location
      existing_bombs[bomb] = "B"
      bomb_count += 1

      bomb_hash = adjacentData(bomb)

      # add the number of bombs each square is touching
      data_hash.merge!(bomb_hash) do |key, old_val, new_val|
        (old_val + new_val)
      end
    end

    data_hash.merge!(existing_bombs)

    data_hash
  end

  # record in-bounds squares touching the given bomb
  def adjacentData(pos)
    row, col = pos
    contacts = {}

    positions = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]

    positions.each do |r, c|
      r += row
      c += col


      if (r >= 0 && r < @board.rows && c >= 0 && c < @board.cols)
        contacts[[r, c]] = 1
      end
    end

    contacts
  end

  def calculateSpotsWithoutBombs()
    total_spots = (@board.rows * @board.cols)
    n_bombs = Math.sqrt(total_spots).to_i - 1

    (total_spots - n_bombs)
  end

  def generateLabelsHash(n)
    labels_hash = {}
    alpha = ('A'..'Z').to_a

    (0...n).each do |n|
      labels_hash[alpha[n]] = n
    end

    labels_hash
  end
end