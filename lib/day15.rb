class Day15 < Base
  class Pos
    def initialize(x, y)
      @x = x
      @y = y
    end

    attr_accessor :x, :y

    def manhattan_distance(other)
      [x - other.x, y - other.y].map(&:abs).sum
    end

    def tuning_frequency
      4000000 * x + y
    end

    def hash
      [x, y].hash
    end

    def eql?(other)
      x == other.x && y == other.y
    end
    alias == eql?

    def to_s
      "<#{x},#{y}>"
    end
    alias inspect to_s
  end

  Sensor = Struct.new(:number, :pos, :closest_beacon) do
    def beacon_distance
      @beacon_distance ||= pos.manhattan_distance(closest_beacon)
    end

    # return a Range covering X coords which this scanner covers at row = y
    def range(y)
      dy = (pos.y - y).abs
      dx = (beacon_distance - dy).abs
      Range.new(pos.x - dx, pos.x + dx) if dy < beacon_distance
    end

    def cover?(other_pos)
      pos.manhattan_distance(other_pos) <= beacon_distance
    end

    def each_edge
      top = pos.y - beacon_distance - 1
      right = pos.x + beacon_distance + 1
      bottom = pos.y + beacon_distance + 1
      left = pos.x - beacon_distance - 1

      edge = Pos.new(pos.x, top)
      until edge.x == right
        yield edge
        edge.x += 1
        edge.y += 1
      end
      until edge.y == bottom
        yield edge
        edge.x -= 1
        edge.y += 1
      end
      until edge.x == left
        yield edge
        edge.x -= 1
        edge.y -= 1
      end
      until edge.y == top
        yield edge
        edge.x += 1
        edge.y -= 1
      end
    end

    def to_s
      "[Sensor #{number} at #{pos}, closest beacon at #{closest_beacon} (#{beacon_distance})]"
    end
  end

  def ordered_ranges(y)
    sensors.map { |s| s.range(y) }.compact.sort_by(&:min)
  end

  def beacons_on_row(y)
    sensors.map(&:closest_beacon).select { |b| b.y == y }.uniq.count
  end

  def part1(y = 2000000)
    lastx = nil
    ordered_ranges(y).sum do |range|
      if lastx && range.min <= lastx
        range.max <= lastx ? 0 : range.last - lastx
      else
        range.size
      end.tap { lastx = [range.last, lastx].compact.max }
    end - beacons_on_row(y)
  end

  def find_gap(y)
    lastx = nil
    candidate = nil
    ordered_ranges(y).each do |range|
      if lastx
        next if range.max <= lastx
        return lastx + 1 if range.min == lastx + 2
      end
      lastx = range.max
    end
    candidate
  end

  def neighbours_covered?(pos)
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dx, dy|
      neighbour = Pos.new(pos.x + dx, pos.y + dy)
      return false if sensors.none? { |s| s.cover?(neighbour) }
    end
    true
  end

  def check_edge(sensor, xrange, yrange)
    sensor.each_edge do |pos|
      next unless yrange.cover?(pos.y) && xrange.cover?(pos.x)

      # still way too slow (~40s, and only because it's next to the 5th sensor!)
      next if sensors.any? { |s| s.cover?(pos) }
      return pos if neighbours_covered?(pos)
    end
    nil
  end

  def part2(mid = 2000000)
    yrange = 0..(mid * 2)
    xrange = Range.new(*sensors.map { |s| s.pos.x }.minmax)
    sensors.each do |s|
      if (pos = check_edge(s, xrange, yrange))
        return pos.tuning_frequency
      end
    end
  end

  def sensors
    @sensors ||=
      raw_input.each_line
               .map { |line| line.match(/^Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)$/) }
               .each_with_index
               .map { |m, i| Sensor.new(i, Pos.new(m[1].to_i, m[2].to_i), Pos.new(m[3].to_i, m[4].to_i)) }
  end
end
