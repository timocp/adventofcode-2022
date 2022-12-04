class Day4 < Base
  def part1
    parse_input.count { |pairs| pairs[0].cover?(pairs[1]) || pairs[1].cover?(pairs[0]) }
  end

  def parse_input
    raw_input.each_line.map do |line|
      line.split(",").map { |range| Range.new(*range.split("-").map(&:to_i)) }
    end
  end
end
