class Day13 < Base
  def part1
    parse_input.each.with_index(1)
               .select { |(left, right), _| correct_order?(left, right) }
               .map { |_, i| i }
               .sum
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
      left.zip(right).each do |l, r|
        if r.nil?
          result = false
          break
        end
        result = correct_order?(l, r, depth + 1)
        break unless result.nil?
      end
      result = true if result.nil? && left.size <= right.size
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
