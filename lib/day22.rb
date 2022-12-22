class Day22 < Base
  class Pos
    def initialize(x, y)
      @x = x
      @y = y
    end

    attr_reader :x, :y

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

  class Board
    def initialize(map)
      parse_map(map)
      @player = Pos.new(@map.keys.select { |p| p.y == 1 }.map(&:x).min, 1)
      @facing = 0
      @cube = false
    end

    attr_reader :player, :facing
    attr_accessor :cube

    def move(steps)
      # print "Moving from #{player} #{steps} times facing #{facing} "
      steps.times do
        nextpos, nextfacing = ahead(player, facing)
        raise "Tried to move off-surface #{nextpos}" unless @map.key?(nextpos)

        case @map[nextpos]
        when :open
          @player = nextpos
          @facing = nextfacing
        when :wall then break
        end
      end
      # puts " -> #{player} #{facing}"
    end

    def turn_right
      @facing = (@facing + 1) % 4
    end

    def turn_left
      @facing = (@facing - 1) % 4
    end

    private

    def ahead(pos, facing)
      nextpos = case facing
                when 3 then Pos.new(pos.x, pos.y - 1)
                when 0 then Pos.new(pos.x + 1, pos.y)
                when 1 then Pos.new(pos.x, pos.y + 1)
                when 2 then Pos.new(pos.x - 1, pos.y)
                end
      if @map.key?(nextpos)
        [nextpos, facing]
      elsif @cube
        wrap_on_cube(nextpos, facing)
      else
        [wrap(pos, facing), facing]
      end
    end

    def wrap(pos, facing)
      case facing
      when 3 then Pos.new(pos.x, @map.keys.select { |p| p.x == pos.x }.map(&:y).max)
      when 0 then Pos.new(@map.keys.select { |p| p.y == pos.y }.map(&:x).min, pos.y)
      when 1 then Pos.new(pos.x, @map.keys.select { |p| p.x == pos.x }.map(&:y).min)
      when 2 then Pos.new(@map.keys.select { |p| p.y == pos.y }.map(&:x).max, pos.y)
      end
    end

    # hardcoded to my input for now.  TODO: make it general purpose (?)
    def wrap_on_cube(pos, facing)
      if pos.x == 50 && (1..50).include?(pos.y)
        # wrap west from A to west edge of D new facing east
        [Pos.new(1, 151 - pos.y), 0]
      elsif pos.x == 50 && (51..100).include?(pos.y)
        # wrap west from C to north edge of D new facing south
        [Pos.new(pos.y - 50, 101), 1]
      elsif pos.x == 0 && (101..150).include?(pos.y)
        # wrap west from D to west edge of A new facing east
        [Pos.new(51, 151 - pos.y), 0]
      elsif pos.x == 0 && (151..200).include?(pos.y)
        # wrap west from F to north edge of A new facing south
        [Pos.new(pos.y - 100, 1), 1]
      elsif pos.x == 51 && (151..200).include?(pos.y)
        # wrap east from F to south edge of E new facing north
        [Pos.new(pos.y - 100, 150), 3]
      elsif pos.x == 101 && (51..100).include?(pos.y)
        # wrap east from C to south edge of B new facing north
        [Pos.new(pos.y + 50, 50), 3]
      elsif pos.x == 101 && (101..150).include?(pos.y)
        # wrap east from E to east edge of B new facing west
        [Pos.new(150, 151 - pos.y), 2]
      elsif pos.x == 151 && (1..50).include?(pos.y)
        # wrap east from B to east edge of E new facing west
        [Pos.new(100, 151 - pos.y), 2]
      elsif pos.y == 0 && (51..100).include?(pos.x)
        # wrap north from A to west edge of F fasting east
        [Pos.new(1, pos.x + 100), 0]
      elsif pos.y == 0 && (101..150).include?(pos.x)
        # wrap north from B to south edge of F facing north
        [Pos.new(pos.x - 100, 200), 3]
      elsif pos.y == 100 && (1..50).include?(pos.x)
        # wrap north from D to west edge of C facing east
        [Pos.new(51, pos.x + 50), 0]
      elsif pos.y == 51 && (101..150).include?(pos.x)
        # wrap south from B to east edge of C facing west
        [Pos.new(100, pos.x - 50), 2]
      elsif pos.y == 151 && (51..100).include?(pos.x)
        # wrap south from E to east edge of F facing west
        [Pos.new(50, pos.x + 100), 2]
      elsif pos.y == 201 && (1..50).include?(pos.x)
        # wrap south from F to north edge of B facing south
        [Pos.new(pos.x + 100, 1), 1]
      end
    end

    def parse_map(map)
      @map = {}
      map.each_line.with_index(1) do |line, y|
        line.chars.each.with_index(1) do |char, x|
          case char
          when "." then @map[Pos.new(x, y)] = :open
          when "#" then @map[Pos.new(x, y)] = :wall
          end
        end
      end
      @map
    end
  end

  def part1
    board, directions = parse_input
    process_directions(board, directions)
  end

  def part2
    board, directions = parse_input
    board.cube = true
    process_directions(board, directions)
  end

  def process_directions(board, directions)
    directions.each do |command, num|
      case command
      when :move then board.move(num)
      when :left then board.turn_left
      when :right then board.turn_right
      end
    end
    board.player.y * 1000 + board.player.x * 4 + board.facing
  end

  def parse_input
    map, directions = raw_input.split("\n\n")
    [Board.new(map), parse_directions(directions)]
  end

  def parse_directions(directions)
    dirs = []
    s = StringScanner.new(directions)
    until s.eos?
      dirs << [:move, s.scan(/\d+/).to_i]
      case s.scan(/[LR]/)
      when "L" then dirs << :left
      when "R" then dirs << :right
      else
        break
      end
    end
    dirs
  end
end
