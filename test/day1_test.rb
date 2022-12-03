require "test_helper"

describe Day1 do
  def setup
    @d = Day1.new
    @d.test_input(<<~TEST)
      1000
      2000
      3000

      4000

      5000
      6000

      7000
      8000
      9000

      10000
    TEST
  end

  def test_part1
    assert_equal 24000, @d.part1
  end
end
