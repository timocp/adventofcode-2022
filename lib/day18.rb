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
    cubes.each.sum do |cube|
      cube.each_neighbour.count do |p|
        !cubes.include?(p)
      end
    end
  end

  def part2
    visited = {}
    count_external_surfaces(Pos3.new(xrange.min, yrange.min, zrange.min), visited)
    visited.values.sum
  end

  # build visited, a hash of Pos3 -> number of surfaces visible from there
  def count_external_surfaces(start, visited)
    stack = Set[start]
    while (pos = stack.first)
      stack.delete(pos)
      visited[pos] = pos.each_neighbour.count { |p| cubes.include?(p) }
      pos.each_neighbour
         .select { |nextpos| in_range?(nextpos) }
         .reject { |nextpos| stack.include?(nextpos) }
         .reject { |nextpos| cubes.include?(nextpos) }
         .reject { |nextpos| visited.key?(nextpos) }
         .each do |nextpos|
        stack.add nextpos
      end
    end
  end

  def cubes
    @cubes ||= raw_input.each_line.map { |line| Pos3.new(*line.split(",").map(&:to_i)) }.to_set
  end

  # ranges for a bounding box (extends 1 pixel past the last cube in each axis)
  def bounding_range(axis)
    minmax = cubes.map(&axis).minmax
    Range.new(minmax[0] - 1, minmax[1] + 1)
  end

  def in_range(pos)
    xrange.cover?(pos.x) && yrange.cover(pos.y) && zrange.cover(pos.z)
  end

  def xrange
    @xrange ||= bounding_range(:x)
  end

  def yrange
    @yrange ||= bounding_range(:y)
  end

  def zrange
    @zrange ||= bounding_range(:z)
  end

  def in_range?(pos)
    @xrange.cover?(pos.x) && @yrange.cover?(pos.y) && zrange.cover?(pos.z)
  end
end
