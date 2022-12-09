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
end
