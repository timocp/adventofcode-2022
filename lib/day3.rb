class Day3 < Base
  def part1
    parse_input.sum { |(comp1, comp2)| priority((comp1 & comp2).first) }
  end

  def priority(item)
    case item
    when "a".."z" then item.ord - "a".ord + 1
    when "A".."Z" then item.ord - "A".ord + 27
    end
  end

  def parse_input
    @parse_input ||= raw_input.split.map do |s|
      s.chars.each_slice(s.length / 2).to_a
    end
  end
end
