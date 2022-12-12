class Day12 < Base
  OFFSET = [[0, -1], [1, 0], [0, 1], [-1, 0]].freeze

  class Pos
    def initialize(x, y)
      @x = x
      @y = y
    end

    attr_reader :x, :y

    def hash
      [x, y].hash
    end

    def each_neighbour
      return to_enum(__method__) unless block_given?

      OFFSET.each do |dx, dy|
        yield self.class.new(x + dx, y + dy)
      end
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
  end

  class Maze
    def initialize(input)
      @map = []
      input.split.each_with_index do |row, y|
        @map << []
        row.each_char.with_index do |cell, x|
          @map.last << parse_cell(cell)
          @start = Pos.new(x, y) if cell == "S"
          @end = Pos.new(x, y) if cell == "E"
        end
      end
    end

    def solve(start = nil)
      queue = [start || @start]
      visited = { queue.first => nil }
      while (pos = queue.shift)
        if pos == @end
          list = [pos]
          while (prev = visited[list.last])
            list << prev
          end
          return list.reverse
        else
          valid_moves[pos.y][pos.x].each do |nextpos|
            next if visited.key?(nextpos)

            queue.push(nextpos)
            visited[nextpos] = pos
          end
        end
      end
    end

    def solve_best_start
      each_pos.map do |pos|
        solve(pos) if edge?(pos) && elevation(pos) == 0
      end.compact.min_by(&:size)
    end

    def elevation(pos)
      @map[pos.y][pos.x]
    end

    def to_s
      @map.each_with_index.map do |row, y|
        row.each_with_index.map do |cell, x|
          if @start.x == x && @start.y == y
            "S"
          elsif @end.x == x && @end.y == y
            "E"
          else
            (cell + "a".ord).chr
          end
        end.join
      end.join("\n")
    end

    private

    def each_pos
      return to_enum(__method__) unless block_given?

      @map.each_with_index do |row, y|
        row.each_index do |x|
          yield Pos.new(x, y)
        end
      end
    end

    def valid?(pos)
      pos.x >= 0 && pos.x < @map.first.size && pos.y >= 0 && pos.y < @map.size
    end

    def edge?(pos)
      pos.x == 0 || pos.y == 0 || pos.x == @map.first.size - 1 || pos.y == @map.size - 1
    end

    def valid_moves
      @valid_moves ||=
        @map.each_with_index.map do |row, y|
          row.each_index.map do |x|
            pos = Pos.new(x, y)
            pos.each_neighbour.select do |nextpos|
              valid?(nextpos) && elevation(nextpos) <= elevation(pos) + 1
            end
          end
        end
    end

    def parse_cell(cell)
      case cell
      when "S" then 0
      when "E" then 25
      else
        cell.ord - "a".ord
      end
    end
  end

  def part1
    parse_input.solve.size - 1
  end

  def part2
    parse_input.solve_best_start.size - 1
  end

  def parse_input
    Maze.new(raw_input)
  end
end
