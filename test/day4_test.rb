require "test_helper"

describe Day4 do
  def setup
    @d = Day4.new
    @d.test_input <<~TEST
      2-4,6-8
      2-3,4-5
      5-7,7-9
      2-8,3-7
      6-6,4-6
      2-6,4-8
    TEST
  end

  def test_part1
    assert_equal 2, @d.part1
  end
end
