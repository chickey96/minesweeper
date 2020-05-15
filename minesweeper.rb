class Minesweeper
  def initialize()
    @board = [['X','X','X'],['X','X','X'],['X','X','X']]
    @data_hash = generateDataHash()
    @game_over = false
    @uncovered = 0
  end

  def playGame()
    until @game_over
      printBoard()
      turn = askPlayerForTurn()
      processResults(turn)
    end

    printBoard()

    if @uncovered == 7
      puts "YOU WON!"
    else
      puts "KABOOOM! YOU LOST!"
    end
  end

  def printBoard()
    puts "  0 1 2 "

    @board.each_with_index do |row, idx|
      puts  idx.to_s + " " + row.join(" ")
    end
  end

  def processResults(pos)
    x, y = pos
    @board[x][y] = @data_hash[pos] || 0
    @uncovered += 1 if (@board[x][y] != -1)

    @game_over = true if (@board[x][y] == -1 || @uncovered == 7)
  end

  def askPlayerForTurn()
    x, y = promptTurn()

    until (isValid?(x, y) && @board[x][y] == 'X')
      if @board[x][y] == 'X'
        puts "Valid column and row indices are between 0 and 2."
        puts "See the top row and leftmost column for reference."
      else
        puts "That space has already been selected. Choose again."
      end

      x, y = promptTurn()
    end

    [x, y]
  end

  def promptTurn()
    puts "Please enter the row of the square you would like to flip next"
    x = gets.chomp.to_i
    puts "Please enter the column of the square you would like to flip next"
    y = gets.chomp.to_i

    [x, y]
  end

  def generateDataHash()
    bomb_1 = [rand(3), rand(3)]
    bomb_2 = [rand(3), rand(3)]

    while (bomb_2 == bomb_1)
      bomb_2 = [rand(3), rand(3)]
    end

    hash = adjacentData(bomb_1)

    hash.merge!(adjacentData(bomb_2)) do |key, old_val, new_val|
      if(key == bomb_1 || key == bomb_2)
        -1
      else
        (old_val + new_val)
      end
    end

    hash
  end

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