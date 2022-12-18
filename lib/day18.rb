class Day18 < Base
  class Pos3
    def initialize(x, y, z)
      @x = x
      @y = y
      @z = z
    end

    attr_reader :x, :y, :z

    SURFACES = [
      [+1, 0, 0],
      [-1, 0, 0],
      [0, +1, 0],
      [0, -1, 0],
      [0, 0, +1],
      [0, 0, -1]
    ].freeze

    def each_neighbour
      return to_enum(__method__) unless block_given?

      SURFACES.each do |dx, dy, dz|
        yield self.class.new(x + dx, y + dy, z + dz)
      end
    end

    def hash
      [x, y, z].hash
    end

    def eql?(other)
      x == other.x && y == other.y && z == other.z
    end
    alias == eql?

    def to_s
      "<#{x},#{y},#{z}>"
    end
    alias inspect to_s
  end

  def part1
    cubes = parse_input.to_set

    cubes.each.sum do |cube|
      cube.each_neighbour.count do |p|
        !cubes.include?(p)
      end
    end
  end

  def parse_input
    raw_input.each_line.map { |line| Pos3.new(*line.split(",").map(&:to_i)) }
  end
end
