require "test_helper"

describe Day17 do
  def setup
    @d = Day17.new
    @d.test_input ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"
  end

  def test_part1
    assert_equal 3068, @d.part1
  end
end
