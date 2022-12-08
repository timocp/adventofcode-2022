require "test_helper"

describe Day8 do
  def setup
    @d = Day8.new
    @d.test_input <<~TEST
      30373
      25512
      65332
      33549
      35390
    TEST
  end

  def test_part1
    assert_equal 21, @d.part1
  end

  def test_part2
    assert_equal 1, @d.scenic_score(1, 1)
    assert_equal 4, @d.scenic_score(1, 2)
    assert_equal 8, @d.scenic_score(3, 2)
    assert_equal 8, @d.part2
  end
end
