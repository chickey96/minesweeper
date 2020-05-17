require './rules_and_setup.rb'
require 'colorize'

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

  # translate user input from alphabetic to numeric, corresponding to grid coordinates
  def getIndexFromLabel(input, type)
    type == 'Row' ? @row_labels_hash[input.upcase] : @col_labels_hash[input.upcase]
  end

  def spotAlreadyUncovered?(x, y)
    return false if @grid[x][y] == "X"
    @rules_and_setup.printInvalidSelectionMessage("That space has already been selected.")
    true
  end

  def inputInBounds?(input, type)
    @rules_and_setup.isValidInput?(input, type)
  end

  def boardFilledOrExploded?()
    @exploded || @spots_to_uncover == 0
  end

  def uncoverSpot(x, y)
    square_val = @data_hash[[x,y]] || 0
    uncoverAllZeroes(x, y) if square_val == 0
    fillInSquare(x, y, square_val)
  end

  # recursively find and uncover any connected zeroes stopping after exposing a non_zero boundary
  def uncoverAllZeroes(row, col, visited={})
    # skip visited and previously uncovered squares
    return false if (@grid[row][col] != 'X' || visited[[row, col]])

    visited[[row, col]] = true
    square_val = @data_hash[[row,col]] || 0

    # stop after uncovering earliest border of non_zero squares
    if (square_val != 0)
      fillInSquare(row, col, square_val)
      return false
    end

    # search coordinates in every possible direction (up/down/left/right and their diagonals)
    surroundings = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]

    surroundings.each do |r, c|
      r += row
      c += col

      # skip out of bounds or already visited squares
      next if visited[[r, c]]
      next unless (@rules_and_setup.isValid?(r, 'Row') && @rules_and_setup.isValid?(c, 'Col'))

      hidden = uncoverAllZeroes(r, c, visited)
      # fill in each square after searching for it's connections
      fillInSquare(r, c) if hidden
    end

    return true
  end

  def fillInSquare(r, c, val=0)
    @grid[r][c] = val
    val == 'B' ? @exploded = true : @spots_to_uncover -= 1
  end

  def printBoardWithOptionalExposure(exposed=false)
    col_labels = "\n   #{@col_labels.join("  ")} \n"
    print (exposed ? col_labels.swap : col_labels)

    @grid.each_with_index do |row, r|
      print (exposed ? "#{@row_labels[r]} ".swap : "#{@row_labels[r]} ")

      # show all hidden values in relief with unicode bombs on exposed view
      if exposed
        row.each_index do |c|
          val = @data_hash[[r,c]] || 0
          print (val == 'B' ? "\u{1F4A3} " : " #{val} ").swap
        end
      else # invert colors of uncovered squares to show them in relief
        row.each { |el| print (el == 'X' ? " #{el} " : " #{el} ".swap) }
      end

      print "\n"
    end

    print "\n"
  end
end