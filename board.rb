class Board
  attr_reader :exploded

  def initialize(game, num_rows=3, num_cols=3)
    @game = game
    @grid = [['X','X','X'],['X','X','X'],['X','X','X']]
    @uncovered_spots = 0
    @labels_hash = {'A'=> 0, 'B'=> 1, 'C'=> 2}
    @labels = @labels_hash.keys
    @data_hash = generateDataHash()
    @exploded = false
  end

  def labelOptionsFor(type)
    @labels[@labels.length-1].to_s
  end

  def getIndexFromLabel(input)
    @labels_hash[input.upcase]
  end

  def printBoard()
    puts "\n  #{@labels.join(" ")}"
    @grid.each_with_index { |row, i| puts @labels[i].to_s + " " + row.join(" ") }
    print "\n"
  end

  def spotAlreadySelected?(x, y)
    return false if @grid[x][y] == "X"

    @game.printInvalidSelectionMessage("That space has already been selected.")

    true
  end

  def hasBombAt?(x, y)
    @grid[x][y] == -1
  end

  def filled?()
    @uncovered_spots == 7
  end

  def uncoverSpot(x, y)
    @grid[x][y] = @data_hash[[x,y]] || 0

    hasBombAt?(x, y) ? @exploded = true : @uncovered_spots += 1
  end

  def boardFilledOrExploded?()
    @exploded || filled?()
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

      if @game.isValid?(pos_x) && @game.isValid?(pos_y)
        contacts[[pos_x, pos_y]] = 1
      end
    end

    contacts
  end


end