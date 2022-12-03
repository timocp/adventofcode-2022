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
end
