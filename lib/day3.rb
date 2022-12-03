class Day3 < Base
  def part1
    parse_input
      .map { |s| s.chars.each_slice(s.length / 2).to_a }
      .sum { |(comp1, comp2)| priority((comp1 & comp2).first) }
  end

  def part2
    parse_input.each_slice(3).sum do |set|
      priority(set.map(&:each_char).map(&:to_a).inject { |memo, obj| memo & obj }.first)
    end
  end

  def priority(item)
    case item
    when "a".."z" then item.ord - "a".ord + 1
    when "A".."Z" then item.ord - "A".ord + 27
    end
  end

  def parse_input
    @parse_input ||= raw_input.split
  end
end
