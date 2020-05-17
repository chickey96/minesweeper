require './rules_and_setup.rb'

class Board
  attr_reader :exploded, :rows, :cols

  def initialize(rows, cols)
    @rows = rows
    @cols = cols

    @rules_and_setup = RulesAndSetup.new(self)
    @grid = @rules_and_setup.generateBoard()
    @data_hash = @rules_and_setup.generateDataHash()
    @spots_to_uncover = @rules_and_setup.calculateSpotsWithoutBombs()

    @row_labels_hash = @rules_and_setup.generateLabelsHash(@rows)
    @col_labels_hash = @rules_and_setup.generateLabelsHash(@cols)
    @row_labels = @row_labels_hash.keys
    @col_labels = @col_labels_hash.keys

    @exploded = false
  end

  def labelOptionsFor(type)
    type == 'Row' ? @row_labels[-1].to_s : @col_labels[-1].to_s
  end

  def getIndexFromLabel(input, type)
    type == 'Row' ? @row_labels_hash[input.upcase] : @col_labels_hash[input.upcase]
  end

  def printBoard()
    puts "\n  #{@col_labels.join(" ")}"
    @grid.each_with_index { |row, i| puts @row_labels[i].to_s + " " + row.join(" ") }
    print "\n"
  end

  def printExposedBoard()
    puts "\n  #{@col_labels.join(" ")}"
    @grid.each_with_index do |row, r|
      puts @row_labels[r].to_s + " " + row.map.with_index{|el, c| @data_hash[[r,c]] || 0}.join(" ")
    end
    print "\n"
  end

  def spotAlreadySelected?(x, y)
    return false if @grid[x][y] == "X"

    @rules_and_setup.printInvalidSelectionMessage("That space has already been selected.")

    true
  end

  def inputInBounds?(input, type)
    @rules_and_setup.isValidInput?(input, type)
  end

  def hasBombAt?(x, y)
    @grid[x][y] == "B"
  end

  def filled?()
    @spots_to_uncover == 0
  end

  def uncoverSpot(x, y)
    @grid[x][y] = @data_hash[[x,y]] || 0

    hasBombAt?(x, y) ? @exploded = true : @spots_to_uncover -= 1
  end

  def boardFilledOrExploded?()
    @exploded || filled?()
  end
end