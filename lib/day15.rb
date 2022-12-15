class Day15 < Base
  class Pos
    def initialize(x, y)
      @x = x
      @y = y
    end

    attr_reader :x, :y

    def manhattan_distance(other)
      [x - other.x, y - other.y].map(&:abs).sum
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

    def to_s
      "[Sensor #{number} at #{pos}, closest beacon at #{closest_beacon} (#{beacon_distance})]"
    end
  end

  def part1(y: 2000000)
    sensors = parse_input

    lastx = nil
    sensors.map { |s| s.range(y) }.compact.sort_by(&:min).sum do |range|
      if lastx && range.min <= lastx
        if range.max <= lastx
          0
        else
          range.last - lastx
        end
      else
        range.size
      end.tap { lastx = [range.last, lastx].compact.max }
    end - sensors.map(&:closest_beacon).select { |b| b.y == y }.uniq.count
  end

  def parse_input
    raw_input.each_line
             .map { |line| line.match(/^Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)$/) }
             .each_with_index
             .map { |m, i| Sensor.new(i, Pos.new(m[1].to_i, m[2].to_i), Pos.new(m[3].to_i, m[4].to_i)) }
  end
end
