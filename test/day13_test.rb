require "test_helper"

describe Day13 do
  def setup
    @d = Day13.new
    @d.test_input <<~TEST
      [1,1,3,1,1]
      [1,1,5,1,1]

      [[1],[2,3,4]]
      [[1],4]

      [9]
      [[8,7,6]]

      [[4,4],4,4]
      [[4,4],4,4,4]

      [7,7,7,7]
      [7,7,7]

      []
      [3]

      [[[]]]
      [[]]

      [1,[2,[3,[4,[5,6,7]]]],8,9]
      [1,[2,[3,[4,[5,6,0]]]],8,9]
    TEST
  end

  def test_part1
    assert_equal 13, @d.part1
  end

  def test_correct_order?
    [
      [],
      [[]],
      [[[]]],
      [1, 1, 3, 1, 1],
      [1, 1, 5, 1, 1],
      [[1], [2, 3, 4]],
      [1, [2, [3, [4, [5, 6, 0]]]], 8, 9],
      [1, [2, [3, [4, [5, 6, 7]]]], 8, 9],
      [[1], 4],
      [[2]],
      [3],
      [[4, 4], 4, 4],
      [[4, 4], 4, 4, 4],
      [[6]],
      [7, 7, 7],
      [7, 7, 7, 7],
      [[8, 7, 6]],
      [9]
    ].each_cons(2) do |a, b|
      assert @d.correct_order?(a, b)
      refute @d.correct_order?(b, a)
    end
  end

  def test_part2
    assert_equal 140, @d.part2
  end
end
