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

  class Game
    def initialize(elves)
      @rounds = 0
      @occupied = elves.to_set
    end

    attr_reader :occupied, :rounds

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
      apply_moves(propose_moves) > 0
    ensure
      @rounds += 1
    end

    def xrange
      Range.new(*occupied.map(&:x).minmax)
    end

    def yrange
      Range.new(*occupied.map(&:y).minmax)
    end

    def display
      xx = xrange
      yrange.map do |y|
        xx.map do |x|
          @occupied.include?(Pos.new(x, y)) ? "#" : "."
        end.join
      end.join("\n")
    end

    private

    # proposed moves is array of [from, to]
    def propose_moves
      occupied.reject { |from| isolated?(from) }
              .map { |from| [from, valid_direction(from)] }
              .reject { |_, to| to.nil? }
    end

    # returns NORTH if N, NE, NW is clear, etc
    def valid_direction(pos)
      offset = 4.times.map { |i| (i + @rounds) % 4 }.map { |dir| DIR_OFFSETS[dir] }.detect do |offsets|
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
      targets = moves.map(&:last).tally
      moves.select { |_, to| targets[to] == 1 }.count do |from, to|
        @occupied.delete(from)
        @occupied.add(to)
      end
    end
  end

  def part1
    game = Game.new(parse_input)
    10.times { game.round }
    game.xrange.size * game.yrange.size - game.occupied.size
  end

  def part2
    game = Game.new(parse_input)
    while game.round
    end
    game.rounds
  end

  def parse_input
    raw_input.each_line.with_index.map do |line, y|
      line.each_char.with_index.select { |cell, _| cell == "#" }.map { |_, x| Pos.new(x, y) }
    end.flatten
  end
end
