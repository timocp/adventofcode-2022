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

    def move_towards(other)
      self.class.new(x + (other.x <=> x), y + (other.y <=> y))
    end
  end

  def part1
    hpos = Pos.new(0, 0)
    tpos = Pos.new(0, 0)
    visited = Set[tpos]
    parse_input.each do |dir, count|
      count.times do
        case dir
        when "U" then hpos.y += 1
        when "R" then hpos.x += 1
        when "D" then hpos.y -= 1
        when "L" then hpos.x -= 1
        end
        tpos = tpos.move_towards(hpos) if tpos.distance(hpos) > 1
        visited.add(tpos)
      end
    end
    visited.size
  end

  def parse_input
    @parse_input ||= raw_input.each_line.map { |line| line.split(" ") }.map { |dir, count| [dir, count.to_i] }
  end
end
