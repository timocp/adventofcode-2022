require "test_helper"

describe Day20 do
  def setup
    @d = Day20.new
    @d.test_input <<~TEST
      1
      2
      -3
      3
      -2
      0
      4
    TEST
  end

  def test_part1
    assert_equal 3, @d.part1
  end

  def test_part2
    assert_equal 1623178306, @d.part2
  end
end
