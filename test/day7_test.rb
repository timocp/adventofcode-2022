require "test_helper"

describe Day7 do
  def setup
    @d = Day7.new
    @d.test_input <<~TEST
      $ cd /
      $ ls
      dir a
      14848514 b.txt
      8504156 c.dat
      dir d
      $ cd a
      $ ls
      dir e
      29116 f
      2557 g
      62596 h.lst
      $ cd e
      $ ls
      584 i
      $ cd ..
      $ cd ..
      $ cd d
      $ ls
      4060174 j
      8033020 d.log
      5626152 d.ext
      7214296 k
    TEST
  end

  def test_part1
    assert_equal 95437, @d.part1
  end

  def test_part2
    assert_equal 24933642, @d.part2
  end
end
