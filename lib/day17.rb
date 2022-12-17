class Day17 < Base
  class Chamber
    def initialize(jet_pattern)
      @rows = []
      @rock_index = 0
      @jet_pattern = jet_pattern
      @jet_index = 0
      @rocks_dropped = 0
    end

    attr_reader :rocks_dropped

    def debug(msg)
      # puts "\n#{msg}:\n#{display}"
    end

    def drop_rock
      add_rock
      loop do
        apply_jet
        if can_move_down?
          move_down
        else
          finish_falling
          break
        end
      end
      @rocks_dropped += 1
    end

    def display
      (
        @rows.each_index.map do |y|
          s = @rows[y].to_s(2).rjust(7, "0").tr("10", "#.")
          if @falling_rock && y >= @falling_y && y < @falling_y + @falling_height
            line = @falling_rock[y - @falling_y]
            6.downto(0) do |b|
              s[6 - b] = "@" if line & 1 << b > 0
            end
          end
          "y=#{y.to_s.ljust(5)} |#{s}| #{@rows[y].to_s.rjust(3)}"
        end.reverse + ["        +-------+"]
      ).join("\n")
    end

    def top_rock_index
      @rows.rindex { |row| row > 0 } || -1
    end

    def detect_repetition
      seen = {}
      loop do
        drop_rock
        key = [@rows[top_rock_index], @jet_index, @rock_index]
        return [rocks_dropped - seen[key][0], top_rock_index - seen[key][1]] if seen.key?(key)

        seen[key] = [rocks_dropped, top_rock_index]
      end
    end

    private

    def add_rock
      rock = ROCKS[@rock_index]
      @rock_index = (@rock_index + 1) % ROCKS.size
      make_space_for_rock(rock)
      @falling_y = top_rock_index + 4  # y position of the bottom row of the fallign rock
      @falling_rock = rock.dup         # array of bitmasks representing the falling rock
      @falling_height = rock.size      # number of rows the falling rock takes up
      debug "A new rock begins falling"
    end

    def make_space_for_rock(rock)
      ((top_rock_index + 4 + rock.size) - @rows.size).times do
        @rows.push(0)
      end
    end

    def apply_jet
      dir = @jet_pattern[@jet_index]
      @jet_index = (@jet_index + 1) % @jet_pattern.size
      if can_move_sideways?(dir)
        move_sideways(dir)
        debug "Jet of gas pushes rock #{dir == 1 ? "left" : "right"}"
      else
        debug "Jet of gas pushes rock #{dir == 1 ? "left" : "right"}, but nothing happens"
      end
    end

    def can_move_sideways?(dir)
      0.upto(@falling_height - 1).none? do |dy|
        (dir == -1 && @falling_rock[dy] & 1 == 1) ||
          (dir == 1 && @falling_rock[dy] & 64 == 64) ||
          (@rows[@falling_y + dy] & @falling_rock[dy] << dir > 0)
      end
    end

    def move_sideways(dir)
      @falling_rock.map! { |r| r << dir }
    end

    def can_move_down?
      @falling_y > 0 &&
        0.upto(@falling_height - 1).none? do |dy|
          @rows[@falling_y + dy - 1] & @falling_rock[dy] > 0
        end
    end

    def move_down
      @falling_y -= 1
      debug "Rock falls 1 unit"
    end

    def finish_falling
      0.upto(@falling_height - 1).each do |dy|
        @rows[@falling_y + dy] = @rows[@falling_y + dy] | @falling_rock[dy]
      end
      @falling_rock = nil
      debug "Rock falls 1 unit, causing it to come to rest"
    end
  end

  # bitmasks representing each rock shape entering at column 3
  ROCKS = [
    [30],             # horizontal line
    [8, 28, 8],       # cross
    [28, 4, 4],       # backwards L - NOTE: reversed to match y indexes
    [16, 16, 16, 16], # vertical line
    [24, 24]          # square block
  ].map(&:freeze).freeze

  def part1
    chamber = Chamber.new(parse_input)
    2022.times { chamber.drop_rock }
    chamber.top_rock_index + 1
  end

  P2_ROCKS = 1000000000000

  def part2
    # run sim for 1000 iterations
    chamber = Chamber.new(parse_input)
    reps, height = chamber.detect_repetition

    # from this position, we know that:
    # rep (1740) rocks dropped will add height (2716) rows
    # and still be in the same state

    # how many times to simulate the rep drops
    simulated_reps = (P2_ROCKS - chamber.rocks_dropped) / reps

    # process a few more to get us to the right final height
    chamber.drop_rock while chamber.rocks_dropped + (simulated_reps * reps) < P2_ROCKS

    chamber.top_rock_index + (simulated_reps * height) + 1
  end

  def parse_input
    @parse_input ||=
      raw_input.chomp.each_char.map do |c|
        case c
        when "<" then 1
        when ">" then -1
        end
      end.freeze
  end
end
