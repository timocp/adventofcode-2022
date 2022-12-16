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

    def top_gap
      Pos.new(pos.x, pos.y - beacon_distance - 1)
    end

    def right_gap
      Pos.new(pos.x + beacon_distance + 1, pos.y)
    end

    def bottom_gap
      Pos.new(pos.x, pos.y + beacon_distance + 1)
    end

    def left_gap
      Pos.new(pos.x - beacon_distance - 1, pos.y)
    end

    def to_s
      "Sensor<#{number} at #{pos}, closest beacon at #{closest_beacon} (#{beacon_distance})>"
    end
    alias inspect to_s
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

  class Line
    def initialize(sensor_number, from, to)
      @sensor_number = sensor_number
      @from = from
      @to = to
    end

    attr_reader :sensor_number, :from, :to

    # intersection point with another line
    # self is always up-to-the-right and other is always down-to-the-right
    def intersection(other)
      return nil if other.from.x > to.x
      return nil if other.to.x < from.x
      return nil if other.from.y > from.y

      # this is the range of columns where both lines exist
      xover = Range.new([from.x, other.from.x].max, [to.x, other.to.x].min)

      # lines can't cross if they are not an even number away from each other at any shared x
      ya = from.y - (xover.min - from.x)
      yb = other.from.y + (xover.min - other.from.x)
      return nil unless (ya - yb).even?

      x = xover.min + (ya - yb) / 2 # x where these lines cross
      Pos.new(x, from.y - (x - from.x)) if xover.cover?(x)
    end
  end

  def find_gap(xrange, yrange)
    # filter just to sensors which happen to be the right distance away from
    # at least one other sensor
    filtered = sensors.combination(2).select do |(a, b)|
      a.pos.manhattan_distance(b.pos) == a.beacon_distance + b.beacon_distance + 2
    end.flatten

    # collect lines covering gaps up-right and down-right
    lines_ur = filtered.map do |s|
      [Line.new(s.number, s.left_gap, s.top_gap), Line.new(s.number, s.bottom_gap, s.right_gap)]
    end.flatten
    lines_dr = filtered.map do |s|
      [Line.new(s.number, s.top_gap, s.right_gap), Line.new(s.number, s.left_gap, s.bottom_gap)]
    end.flatten

    # any intersection is a candidate, but needs to be checked it is in range
    # and is not covered by another scanner
    lines_ur.each do |line1|
      lines_dr.reject { |line2| line2.sensor_number == line1.sensor_number }
              .map { |line2| line1.intersection(line2) }.compact
              .select { |pos| xrange.cover?(pos.x) && yrange.cover?(pos.y) }
              .each do |pos|
        return pos if sensors.none? { |s| s.cover?(pos) }
      end
    end
    nil
  end

  def part2(mid = 2000000)
    xrange = Range.new(*sensors.map { |s| s.pos.x }.minmax)
    yrange = 0..(mid * 2)
    find_gap(xrange, yrange)&.tuning_frequency
  end

  def sensors
    @sensors ||=
      raw_input.each_line
               .map { |line| line.match(/^Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)$/) }
               .each_with_index
               .map { |m, i| Sensor.new(i, Pos.new(m[1].to_i, m[2].to_i), Pos.new(m[3].to_i, m[4].to_i)) }
  end
end
