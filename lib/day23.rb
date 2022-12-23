class Day23 < Base
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

  class Elf
    def initialize(x, y)
      @pos = Pos.new(x, y)
    end

    attr_accessor :pos
  end

  class Game
    def initialize(elves)
      @elves = elves
      @rounds = 0
    end

    attr_reader :elves, :rounds

    NORTH = 0
    SOUTH = 1
    EAST = 2
    WEST = 3

    DIR_OFFSETS = [
      [[+0, -1], [+1, -1], [-1, -1]], # N, NE, NW
      [[+0, +1], [+1, +1], [-1, +1]], # S, SE, SW
      [[-1, +0], [-1, -1], [-1, +1]], # W, NW, SW
      [[+1, +0], [+1, -1], [+1, +1]]  # E, NE, SE
    ].freeze

    def round
      @occupied = elves.map(&:pos).to_set
      apply_moves(propose_moves)
      @occupied = nil
      @rounds += 1
    end

    def xrange
      Range.new(*elves.map(&:pos).map(&:x).minmax)
    end

    def yrange
      Range.new(*elves.map(&:pos).map(&:y).minmax)
    end

    def display
      occupied = elves.map(&:pos).to_set
      xx = xrange
      yrange.map do |y|
        xx.map do |x|
          occupied.include?(Pos.new(x, y)) ? "#" : "."
        end.join
      end.join("\n")
    end

    private

    def propose_moves
      elves.each_with_index
           .reject { |elf, _| isolated?(elf.pos) }
           .map { |elf, i| [valid_direction(elf.pos), i] }
           .reject { |nextpos, _| nextpos.nil? }
    end

    # returns NORTH if N, NE, NW is clear, etc
    def valid_direction(pos)
      offset = 4.times.to_a.rotate(@rounds % 4).map { |dir| DIR_OFFSETS[dir] }.detect do |offsets|
        offsets.none? { |(dx, dy)| @occupied.include?(Pos.new(pos.x + dx, pos.y + dy)) }
      end&.first
      Pos.new(pos.x + offset[0], pos.y + offset[1]) if offset
    end

    def isolated?(pos)
      [-1, 0, 1].each do |dy|
        [-1, 0, 1].each do |dx|
          next if dx == 0 && dy == 0

          return false if @occupied.include?(Pos.new(pos.x + dx, pos.y + dy))
        end
      end
      true
    end

    def apply_moves(moves)
      targets = moves.map(&:first).tally
      moves.select { |nextpos, _| targets[nextpos] == 1 }.each do |(nextpos, i)|
        elves[i].pos = nextpos
      end
    end
  end

  def part1
    game = Game.new(parse_input)
    # 10.times { puts; game.round; puts "== End of Round #{game.rounds} =="; puts game.display }
    10.times { game.round }
    game.xrange.size * game.yrange.size - game.elves.size
  end

  def parse_input
    raw_input.each_line.with_index.map do |line, y|
      line.each_char.with_index.select { |cell, _| cell == "#" }.map { |_, x| Elf.new(x, y) }
    end.flatten
  end
end
