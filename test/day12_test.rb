require "test_helper"

describe Day12 do
  def setup
    @d = Day12.new
    @d.test_input <<~TEST
      Sabqponm
      abcryxxl
      accszExk
      acctuvwj
      abdefghi
    TEST
  end

  def test_part1
    assert_equal 31, @d.part1
  end
end
