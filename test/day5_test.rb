require "test_helper"

describe Day5 do
  def setup
    @d = Day5.new
    @d.test_input <<~TEST
          [D]
      [N] [C]
      [Z] [M] [P]
       1   2   3

      move 1 from 2 to 1
      move 3 from 1 to 3
      move 2 from 2 to 1
      move 1 from 1 to 2
    TEST
  end

  def test_part1
    assert_equal "CMZ", @d.part1
  end

  def test_part2
    assert_equal "MCD", @d.part2
  end
end
