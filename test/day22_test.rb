require "test_helper"

describe Day22 do
  def setup
    @d = Day22.new
    @d.test_input <<~TEST
              ...#
              .#..
              #...
              ....
      ...#.......#
      ........#...
      ..#....#....
      ..........#.
              ...#....
              .....#..
              .#......
              ......#.

      10R5L5R10L4R5L5
    TEST
  end

  def test_part1
    assert_equal 6032, @d.part1
  end
end
