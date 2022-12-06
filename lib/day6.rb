class Day6 < Base
  def part1
    find_unique(4)
  end

  def part2
    find_unique(14)
  end

  def find_unique(len)
    parse_input.each_cons(len).find_index { |ary| ary.uniq.size == len } + len
  end

  def parse_input
    raw_input.chomp.split("")
  end
end
