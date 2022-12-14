require "test_helper"

describe Day6 do
  def setup
    @d = Day6.new
  end

  def test_part1
    assert_equal 7, @d.test_input("mjqjpqmgbljsphdztnvjfqwrcgsmlb").part1
    assert_equal 5, @d.test_input("bvwbjplbgvbhsrlpgdmjqwftvncz").part1
    assert_equal 6, @d.test_input("nppdvjthqldpwncqszvftbrmjlhg").part1
    assert_equal 10, @d.test_input("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg").part1
    assert_equal 11, @d.test_input("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw").part1
  end

  def test_part2
    assert_equal 19, @d.test_input("mjqjpqmgbljsphdztnvjfqwrcgsmlb").part2
    assert_equal 23, @d.test_input("bvwbjplbgvbhsrlpgdmjqwftvncz").part2
    assert_equal 23, @d.test_input("nppdvjthqldpwncqszvftbrmjlhg").part2
    assert_equal 29, @d.test_input("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg").part2
    assert_equal 26, @d.test_input("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw").part2
  end
end
