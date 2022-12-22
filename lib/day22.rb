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
    end

    attr_reader :player, :facing

    def move(steps)
      # print "Moving from #{player} #{steps} times facing #{facing} "
      steps.times do
        nextpos = ahead(player, facing)
        raise "Tried to move off-durface #{nextpos}" unless @map.key?(nextpos)

        case @map[nextpos]
        when :open then @player = nextpos
        when :wall then break
        end
      end
      # puts " -> #{player}"
    end

    def turn_right
      @facing = (@facing + 1) % 4
    end

    def turn_left
      @facing = (@facing - 1) % 4
    end

    def ahead(pos, facing)
      nextpos = case facing
                when 3 then Pos.new(pos.x, pos.y - 1)
                when 0 then Pos.new(pos.x + 1, pos.y)
                when 1 then Pos.new(pos.x, pos.y + 1)
                when 2 then Pos.new(pos.x - 1, pos.y)
                end
      if @map.key?(nextpos)
        nextpos
      else
        wrap(pos, facing)
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

    private

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
