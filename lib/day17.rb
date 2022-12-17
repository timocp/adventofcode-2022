class Day17 < Base
  class Chamber
    def initialize(jet_pattern)
      @rows = []
      @rocks = ROCKS.cycle
      @jet_pattern = jet_pattern.cycle
    end

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
    end

    def display
      (
        @rows.reverse.map { |row| "|#{row.map { |r| r || "." }.join}|" } + ["+-------+"]
      ).join("\n")
    end

    def top_rock_index
      @rows.rindex(&:any?) || -1
    end

    private

    def add_rock
      rock = @rocks.next
      make_space_for_rock(rock)
      @falling_y = top_rock_index + 4
      @falling_height = rock.each_line.count
      rock.each_line.with_index(1).each do |line, dy|
        line.chars.each_with_index do |c, x|
          @rows[@falling_y + @falling_height - dy][x + 2] = "@" if c == "#"
        end
      end
      debug "A new rock begins falling"
    end

    def make_space_for_rock(rock)
      ((top_rock_index + 4 + rock.each_line.count) - @rows.size).times do
        @rows.push(Array.new(7))
      end
    end

    def apply_jet
      dir = @jet_pattern.next
      move_sideways(dir) if can_move_sideways?(dir)
      debug "Jet of gas pushes rock #{dir == 1 ? "right" : "left"}"
    end

    def can_move_sideways?(dir)
      @falling_y.upto(@falling_y + @falling_height - 1).each do |y|
        @rows[y].each.with_index.select { |r, _| r == "@" }.each do |_, x|
          xp = x + dir
          return false if xp < 0 || xp > 6 || @rows[y][xp] == "#"
        end
      end
      true
    end

    def move_sideways(dir)
      @falling_y.upto(@falling_y + @falling_height - 1).each do |y|
        @rows[y].replace(
          7.times.map do |x|
            if @rows[y][x] == "#"
              "#"
            elsif @rows[y][x - dir] == "@"
              "@"
            end
          end
        )
      end
    end

    def can_move_down?
      return false if @falling_y == 0

      (@falling_y - 1).upto(@falling_y + @falling_height - 2).each do |y|
        @rows[y].each.with_index do |r, x|
          return false if r == "#" && @rows[y + 1][x] == "@"
        end
      end
      true
    end

    def move_down
      (@falling_y - 1).upto(@falling_y + @falling_height - 2).each do |y|
        @rows[y].replace(
          7.times.map do |x|
            if @rows[y][x] == "#"
              "#"
            elsif @rows[y + 1][x] == "@"
              "@"
            end
          end
        )
      end
      @rows[@falling_y + @falling_height - 1].map! { |r| r == "@" ? nil : r }
      @falling_y -= 1
      debug "Rock falls 1 unit"
    end

    def finish_falling
      @falling_y.upto(@falling_y + @falling_height - 1).each do |y|
        @rows[y].map! { |r| r == "@" ? "#" : r }
      end
      debug "Rock falls 1 unit, causing it to come to rest"
    end
  end

  ROCKS = [
    "####",
    " # \n###\n # ",
    "  #\n  #\n###",
    "#\n#\n#\n#",
    "##\n##"
  ].freeze

  def part1
    chamber = Chamber.new(parse_input)
    2022.times { chamber.drop_rock }
    chamber.top_rock_index + 1
  end

  def parse_input
    raw_input.chomp.each_char.map do |c|
      case c
      when "<" then -1
      when ">" then 1
      end
    end
  end
end
