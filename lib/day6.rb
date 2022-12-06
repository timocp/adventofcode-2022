class Day6 < Base
  def part1
    0.upto(input.length) do |i|
      return i + 4 if input[i, 4].uniq.size == 4
    end
  end

  def input
    raw_input.chomp.split("")
  end
end
