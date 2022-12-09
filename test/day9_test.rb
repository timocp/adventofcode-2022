require "test_helper"

describe Day9 do
  def setup
    @d = Day9.new
    @d.test_input <<~TEST
      R 4
      U 4
      L 3
      D 1
      R 4
      D 1
      L 5
      R 2
    TEST
  end

  def test_part1
    assert_equal 13, @d.part1
  end

  def test_part2
    assert_equal 1, @d.part2
    assert_equal 36, @d.test_input(<<~TEST).part2
      R 5
      U 8
      L 8
      D 3
      R 17
      D 10
      L 25
      U 20
    TEST
  end
end
