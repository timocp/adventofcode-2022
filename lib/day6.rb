class Day6 < Base
  def part1
    input = parse_input
    0.upto(input.length) do |i|
      return i + 4 if input[i, 4].uniq.size == 4
    end
  end

  def part2
    input = parse_input
    0.upto(input.length) do |i|
      return i + 14 if input[i, 14].uniq.size == 14
    end
  end

  def parse_input
    raw_input.chomp.split("")
  end
end
