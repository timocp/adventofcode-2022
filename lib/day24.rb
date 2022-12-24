class Day24 < Base
  class Valley
    def initialize(width, height)
      @width = width
      @height = height
      @data = [Array.new(width * height) { 0 }]
      @entrance = nil
      @exit = nil
      @repeat = @width * @height
    end

    attr_reader :width, :height
    attr_accessor :entrance, :exit

    # @data is an array of 2d grids, representing wind configuration at `index`
    # minutes.
    NORTH = 1
    EAST = 2
    SOUTH = 4
    WEST = 8

    def place_wind(x, y, direction)
      raise "Out of bounds" if x < 0 || x >= width || y < 0 || y >= height

      @data[0][y * width + x] |= direction
    end

    # returns true if we can move to coord at time
    # out of bounds or any wind prevents movement
    def clear?(x, y, time)
      return false if x < 0 || x >= width || y < 0 || y >= height

      tick while time % @repeat > @data.size - 1

      @data[time % @repeat][y * width + x] == 0
    end

    # calculate the next wind state
    def tick
      new_winds = Array.new(width * height)
      height.times do |y|
        width.times do |x|
          new_winds[y * width + x] = next_wind(x, y)
        end
      end
      @data.push new_winds
    end

    def next_wind(x, y)
      (@data.last[((y + 1) % height) * width + x] & NORTH) |
        (@data.last[((y - 1) % height) * width + x] & SOUTH) |
        (@data.last[y * width + (x + 1) % width] & WEST) |
        (@data.last[y * width + (x - 1) % width] & EAST)
    end

    def display(time)
      tick while time % @repeat > @data.size - 1

      output = ["#" * (width + 2)]
      height.times do |y|
        line = ""
        width.times do |x|
          line += case @data[time % @repeat][y * width + x]
                  when 0     then "."
                  when NORTH then "^"
                  when EAST  then ">"
                  when SOUTH then "v"
                  when WEST  then "<"
                  else
                    # multiple winds
                    @data[time % @repeat][y * width + x].to_s(2).count("1").to_s
                  end
        end
        output << "##{line}#"
      end
      output << "#" * (width + 2)
      output[0][entrance + 1] = "."
      output[-1][exit + 1] = "."
      output.join("\n")
    end
  end

  def part1
    path_through_valley(valley, [valley.entrance, -1, 0], [valley.exit, valley.height - 1])
  end

  def part2
    t = path_through_valley(valley, [valley.entrance, -1, 0], [valley.exit, valley.height - 1])
    t = path_through_valley(valley, [valley.exit, valley.height, t], [valley.entrance, 0])
    path_through_valley(valley, [valley.entrance, -1, t], [valley.exit, valley.height - 1])
  end

  class State
    def initialize(x, y, time)
      @x = x
      @y = y
      @time = time
    end

    attr_reader :x, :y, :time

    def hash
      [x, y, time].hash
    end

    def eql?(other)
      x == other.x && y == other.y && time == other.time
    end
    alias == eql?

    def to_s
      "<#{x},#{y} at t#{time}>"
    end
    alias inspect to_s
  end

  # NOTE: "to" can't be in the wall so need to add 1 to account for the final move
  def path_through_valley(v, from, to)
    queue = Set.new # set instead of array to avoid duplicates
    queue.add State.new(*from)
    while (s = queue.first)
      queue.delete(s)
      return s.time + 1 if s.x == to[0] && s.y == to[1]

      queue.add State.new(s.x, s.y + 1, s.time + 1) if v.clear?(s.x, s.y + 1, s.time + 1)
      queue.add State.new(s.x + 1, s.y, s.time + 1) if v.clear?(s.x + 1, s.y, s.time + 1)
      queue.add State.new(s.x, s.y, s.time + 1) if s.y == -1 || s.y == valley.height || v.clear?(s.x, s.y, s.time + 1)
      queue.add State.new(s.x - 1, s.y, s.time + 1) if v.clear?(s.x - 1, s.y, s.time + 1)
      queue.add State.new(s.x, s.y - 1, s.time + 1) if v.clear?(s.x, s.y - 1, s.time + 1)
    end
  end

  def valley
    @valley ||= parse_input
  end

  def parse_input
    # height/width ignores walls
    input = raw_input.lines.map(&:chomp)
    width = input.first.size - 2
    height = input.size - 2
    v = Valley.new(width, height)
    input.each.with_index(-1) do |line, y|
      line.each_char.with_index(-1) do |c, x|
        case c
        when "^" then v.place_wind(x, y, Valley::NORTH)
        when ">" then v.place_wind(x, y, Valley::EAST)
        when "v" then v.place_wind(x, y, Valley::SOUTH)
        when "<" then v.place_wind(x, y, Valley::WEST)
        end
      end
    end
    v.entrance = input.first.index(".") - 1
    v.exit = input.last.index(".") - 1
    v
  end
end
