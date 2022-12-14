class Day14 < Base
  class Pos
    def initialize(x, y)
      @x = x
      @y = y
    end

    attr_reader :x, :y

    def down
      self.class.new(x, y + 1)
    end

    def down_left
      self.class.new(x - 1, y + 1)
    end

    def down_right
      self.class.new(x + 1, y + 1)
    end

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
      @yrange = Range.new(0, @contents.keys.map(&:y).max)
      @xrange = Range.new(*@contents.keys.map(&:x).minmax)
      @contents[ENTRY] = :entry
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

    def to_s
      @yrange.map do |y|
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
    # nil if it will fall forever
    def drop_sand
      pos = ENTRY
      while (nextpos = [pos.down, pos.down_left, pos.down_right].detect { |p| @contents[p].nil? })
        pos = nextpos
        return nil if pos.y >= @yrange.max
      end
      pos
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

  def cave
    Cave.new(raw_input)
  end
end
