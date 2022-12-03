require "test_helper"

describe Day2 do
  def setup
    @d = Day2.new
    @d.test_input <<~TEST
      A Y
      B X
      C Z
    TEST
  end

  def test_part1
    assert_equal 15, @d.part1
  end

  def test_part2
    assert_equal 12, @d.part2
  end
end
