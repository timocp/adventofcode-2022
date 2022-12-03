require "test_helper"

describe Day3 do
  def setup
    @d = Day3.new
    @d.test_input <<~TEST
      vJrwpWtwJgWrhcsFMMfFFhFp
      jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
      PmmdzqPrVvPwwTWBwg
      wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
      ttgJtRGJQctTZtZT
      CrZsJsPPZsGzwwsLwLmpwMDw
    TEST
  end

  def test_part1
    assert_equal 157, @d.part1
  end

  def test_part2
    assert_equal 70, @d.part2
  end
end
