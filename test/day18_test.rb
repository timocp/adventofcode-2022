require "test_helper"

describe Day18 do
  def setup
    @d = Day18.new
    @d.test_input <<~TEST
      2,2,2
      1,2,2
      3,2,2
      2,1,2
      2,3,2
      2,2,1
      2,2,3
      2,2,4
      2,2,6
      1,2,5
      3,2,5
      2,1,5
      2,3,5
    TEST
  end

  def test_part1
    assert_equal 64, @d.part1
  end
end
