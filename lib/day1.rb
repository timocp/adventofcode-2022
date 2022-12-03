class Day1 < Base
  def part1
    parse_input.map(&:sum).max
  end

  def part2
    parse_input.map(&:sum).sort.last(3).sum
  end

  def parse_input
    @parse_input ||= raw_input.split(/\n\n/).map { |group| group.split.map(&:to_i) }
  end
end
