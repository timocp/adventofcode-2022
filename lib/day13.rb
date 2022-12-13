class Day13 < Base
  def part1
    parse_input.each.with_index(1)
               .select { |(left, right), _| correct_order?(left, right) }
               .map { |_, i| i }
               .sum
  end

  DIVIDER1 = [[2]].freeze
  DIVIDER2 = [[6]].freeze

  def part2
    packets = (parse_input.map(&:first) + parse_input.map(&:last) + [DIVIDER1, DIVIDER2]).sort do |a, b|
      if a == b
        0
      elsif correct_order?(a, b)
        -1
      else
        1
      end
    end
    (packets.index(DIVIDER1) + 1) * (packets.index(DIVIDER2) + 1)
  end

  def correct_order?(left, right, depth = 1)
    # puts if depth == 1
    # print "- ".rjust(depth * 2, " ")
    # puts "Compare #{left.inspect} vs #{right.inspect}"
    result = nil
    if left.is_a?(Integer) && right.is_a?(Integer)
      result = true if left < right
      result = false if left > right
    elsif left.is_a?(Array) && right.is_a?(Array)
      0.upto([left.size, right.size].max) do |i|
        if right.size < i
          result = false
          break
        elsif left.size < i
          result = true
          break
        end
        result = correct_order?(left[i], right[i])
        return result unless result.nil?
      end
    elsif left.is_a?(Array) && right.is_a?(Integer)
      result = correct_order?(left, Array(right), depth + 1)
    elsif left.is_a?(Integer) && right.is_a?(Array)
      result = correct_order?(Array(left), right, depth + 1)
    end
    # print "> ".rjust(depth * 2, " ")
    # puts "Returning: #{result.inspect}"
    # puts if depth == 1
    result
  end

  def parse_input
    raw_input.split("\n\n").map { |pairs| pairs.split("\n").map { |list| JSON.parse(list) } }
  end
end
