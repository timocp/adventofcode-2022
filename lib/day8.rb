class Day8 < Base
  def part1
    visible = Set.new
    (0...size).each do |n|
      coords = [n].product((0...size).to_a)
      scan(coords, visible)
      scan(coords.reverse, visible)
      coords = (0...size).to_a.product([n])
      scan(coords, visible)
      scan(coords.reverse, visible)
    end
    visible.size
  end

  def scan(coords, visible)
    h = -1
    coords.each do |(row, col)|
      if height(row, col) > h
        visible.add([row, col])
        h = height(row, col)
      end
    end
  end

  def size
    grid.size
  end

  def height(row, col)
    grid[row][col]
  end

  def grid
    @grid ||= raw_input.each_line.map { |line| line.split("").map(&:to_i) }
  end
end
