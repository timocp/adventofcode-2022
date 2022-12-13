class Day13 < Base
  def part1
    packet_pairs.each.with_index(1)
                .select { |(left, right), _| compare_packets(left, right) == CORRECT }
                .sum(&:last)
  end

  DIVIDER1 = [[2]].freeze
  DIVIDER2 = [[6]].freeze

  def part2
    packets = (packet_pairs.map(&:first) + packet_pairs.map(&:last) + [DIVIDER1, DIVIDER2]).sort do |a, b|
      compare_packets(a, b) || 0
    end
    (packets.index(DIVIDER1) + 1) * (packets.index(DIVIDER2) + 1)
  end

  # return values so that comparison can work like <=>
  CORRECT = -1
  INCORRECT = 1

  def compare_packets(left, right)
    if left.is_a?(Integer) && right.is_a?(Integer)
      compare_integers(left, right)
    elsif left.is_a?(Array) && right.is_a?(Array)
      compare_arrays(left, right)
    else
      compare_packets(Array(left), Array(right))
    end
  end

  def compare_integers(left, right)
    if left < right
      CORRECT
    elsif left > right
      INCORRECT
    end
  end

  def compare_arrays(left, right)
    0.upto([left.size, right.size].max) do |i|
      return nil if i >= left.size && i >= right.size
      return INCORRECT if i >= right.size
      return CORRECT if i >= left.size

      result = compare_packets(left[i], right[i])
      return result if result
    end
  end

  def packet_pairs
    @packet_pairs ||= raw_input.split("\n\n").map { |pairs| pairs.split("\n").map { |list| JSON.parse(list) } }
  end
end
