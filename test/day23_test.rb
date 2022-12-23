require "test_helper"

describe Day23 do
  def setup
    @d = Day23.new
    @d.test_input <<~TEST
      ....#..
      ..###.#
      #...#.#
      .#...##
      #.###..
      ##.#.##
      .#..#..
    TEST
  end

  def test_part1
    assert_equal 110, @d.part1
  end

  def test_part1_small
    @d.test_input <<~TEST
      .....
      ..##.
      ..#..
      .....
      ..##.
      .....
    TEST
    assert_equal 25, @d.part1
  end
end
