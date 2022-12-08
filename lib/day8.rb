class Day8 < Base
  def part1
    visible = Set.new
    (0...size).each do |n|
      coords = [n].product((0...size).to_a)
      scan_from_edge(coords, visible)
      scan_from_edge(coords.reverse, visible)
      coords = (0...size).to_a.product([n])
      scan_from_edge(coords, visible)
      scan_from_edge(coords.reverse, visible)
    end
    visible.size
  end

  def part2
    (1...(size - 1)).to_a.product((1..(size - 1)).to_a).map { |row, col| scenic_score(row, col) }.max
  end

  def scenic_score(row, col)
    h = height(row, col)
    [
      scan_from_tree((row - 1).downto(0).to_a.product([col]), h),
      scan_from_tree([row].product((col - 1).downto(0).to_a), h),
      scan_from_tree((row + 1).upto(size - 1).to_a.product([col]), h),
      scan_from_tree([row].product((col + 1).upto(size - 1).to_a), h)
    ].inject(&:*)
  end

  def scan_from_edge(coords, visible)
    h = -1
    coords.each do |(row, col)|
      if height(row, col) > h
        visible.add([row, col])
        h = height(row, col)
      end
    end
  end

  def scan_from_tree(coords, max)
    count = 0
    coords.each do |(row, col)|
      count += 1
      break if height(row, col) >= max
    end
    count
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
