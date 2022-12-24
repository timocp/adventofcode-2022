require "test_helper"

describe Day24 do
  def setup
    @d = Day24.new
    @d.test_input <<~TEST
      #.######
      #>>.<^<#
      #.<..<<#
      #>v.><>#
      #<^v^^>#
      ######.#
    TEST
  end

  def test_part1
    assert_equal 18, @d.part1
  end

  def test_part2
    assert_equal 54, @d.part2
  end
end
