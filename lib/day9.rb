class Day9 < Base
  Pos = Struct.new(:x, :y) do
    def hash
      [x, y].hash
    end

    def inspect
      "<#{x},#{y}>"
    end
    alias_method :to_s, :inspect

    def distance(other)
      [(other.x - x).abs, (other.y - y).abs].max
    end

    def move(dir)
      case dir
      when "U" then self.y += 1
      when "R" then self.x += 1
      when "D" then self.y -= 1
      when "L" then self.x -= 1
      end
    end

    def move_towards(other)
      self.class.new(x + (other.x <=> x), y + (other.y <=> y))
    end
  end

  def part1
    measure(2)
  end

  def part2
    measure(10)
  end

  def measure(knots)
    rope = knots.times.map { Pos.new(0, 0) }
    visited = Set[rope.last]
    parse_input.each do |dir|
      rope.first.move(dir)
      rope.each_with_index do |pos, i|
        rope[i] = pos.move_towards(rope[i - 1]) if i > 0 && pos.distance(rope[i - 1]) > 1
      end
      visited.add(rope.last)
    end
    visited.size
  end

  def parse_input
    raw_input.each_line.map { |line| line.split(" ") }.map { |dir, count| [dir] * count.to_i }.flatten
  end
end
