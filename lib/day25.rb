class Day25 < Base
  SNAFU_DIGIT = {
    "2" => 2,
    "1" => 1,
    "0" => 0,
    "-" => -1,
    "=" => -2
  }.freeze

  def snafu_to_integer(snafu)
    snafu.chars.inject(0) { |acc, c| acc * 5 + SNAFU_DIGIT[c] }
  end

  def integer_to_snafu(int)
    s = ""
    carry = 0
    while int > 0 || carry > 0
      carry, x = case int % 5 + carry
                 when 0 then [0, "0"]
                 when 1 then [0, "1"]
                 when 2 then [0, "2"]
                 when 3 then [1, "="]
                 when 4 then [1, "-"]
                 when 5 then [1, "0"]
                 end
      s = "#{x}#{s}"
      int /= 5
    end
    s
  end

  def part1
    integer_to_snafu(raw_input.lines.map(&:chomp).map { |snafu| snafu_to_integer(snafu) }.sum)
  end
end
