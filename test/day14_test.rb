require "test_helper"

describe Day14 do
  def setup
    @d = Day14.new
    @d.test_input <<~TEST
      498,4 -> 498,6 -> 496,6
      503,4 -> 502,4 -> 502,9 -> 494,9
    TEST
  end

  def test_cave
    cave = Day14::Cave.new(@d.raw_input)
    assert_equal <<~CAVE.chomp, cave.to_s
      ......+...
      ..........
      ..........
      ..........
      ....#...##
      ....#...#.
      ..###...#.
      ........#.
      ........#.
      #########.
    CAVE
    cave.fill
    assert_equal <<~CAVE.chomp, cave.to_s
      ......+...
      ..........
      ......o...
      .....ooo..
      ....#ooo##
      ...o#ooo#.
      ..###ooo#.
      ....oooo#.
      .o.ooooo#.
      #########.
    CAVE
  end

  def test_part1
    assert_equal 24, @d.part1
  end
end
