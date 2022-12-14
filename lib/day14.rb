class Day14 < Base
  class Pos
    def initialize(x, y)
      @x = x
      @y = y
    end

    attr_accessor :x, :y

    def hash
      [x, y].hash
    end

    def ==(other)
      x == other.x && y == other.y
    end

    def eql?(other)
      self.==(other)
    end

    def inspect
      "<#{x},#{y}>"
    end
    alias to_s inspect

    def walk_to(other)
      if x == other.x
        Range.new(*[y, other.y].minmax).map { |p| self.class.new(x, p) }
      elsif y == other.y
        Range.new(*[x, other.x].minmax).map { |p| self.class.new(p, y) }
      end
    end
  end

  ENTRY = Pos.new(500, 0)

  class Cave
    def initialize(input)
      @contents = {} # Pos -> :entry | :rock | :sand
      parse_input(input)
      set_boundaries
      @contents[ENTRY] = :entry
    end

    def set_boundaries
      @ymax = @contents.keys.map(&:y).max
      @xrange = Range.new(*@contents.keys.map(&:x).minmax)
    end

    def place_rock(from, to)
      from.walk_to(to).each { |pos| @contents[pos] = :rock }
    end

    def fill
      while (pos = drop_sand)
        @contents[pos] = :sand
      end
    end

    def count_sand
      @contents.values.count { |v| v == :sand }
    end

    def add_floor
      floor = @ymax + 2
      ((ENTRY.x - floor)..(ENTRY.x + floor)).each { |x| @contents[Pos.new(x, floor)] = :rock }
      set_boundaries
    end

    def to_s
      (0..@ymax).map do |y|
        @xrange.map do |x|
          case @contents[Pos.new(x, y)]
          when :entry then "+"
          when :rock  then "#"
          when :sand  then "o"
          when nil    then "."
          else
            "?"
          end
        end.join("")
      end.join("\n")
    end

    private

    # returns the next position sand can drop to
    # nil if it will fall forever (part 1) or cannot be dropped (part 2)
    def drop_sand
      return nil if @contents[ENTRY] == :sand

      pos = ENTRY
      while (nextpos = move_sand(pos))
        pos = nextpos
        return nil if pos.y >= @ymax
      end
      pos
    end

    def move_sand(pos)
      nextpos = Pos.new(pos.x, pos.y + 1)
      return nextpos unless @contents.key?(nextpos)

      nextpos.x -= 1
      return nextpos unless @contents.key?(nextpos)

      nextpos.x += 2
      return nextpos unless @contents.key?(nextpos)

      nil
    end

    def parse_input(input)
      input.each_line do |line|
        line.split(" -> ")
            .map { |coord| Pos.new(*coord.split(",").map(&:to_i)) }
            .each_cons(2) { |from, to| place_rock(from, to) }
      end
    end
  end

  def part1
    cave.tap(&:fill).count_sand
  end

  def part2
    cave.tap(&:add_floor).tap(&:fill).count_sand
  end

  def cave
    @cave ||= Cave.new(raw_input)
  end
end
