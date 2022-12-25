require "test_helper"

describe Day25 do
  def setup
    @d = Day25.new
    @d.test_input <<~TEST
      1=-0-2
      12111
      2=0=
      21
      2=01
      111
      20012
      112
      1=-1=
      1-12
      12
      1=
      122
    TEST
  end

  def test_part1
    assert_equal "2=-1=0", @d.part1
  end

  def test_snafu_conversion
    [
      [1, "1"],
      [2, "2"],
      [3, "1="],
      [4, "1-"],
      [5, "10"],
      [6, "11"],
      [7, "12"],
      [8, "2="],
      [9, "2-"],
      [10, "20"],
      [15, "1=0"],
      [20, "1-0"],
      [2022, "1=11-2"],
      [12345, "1-0---0"],
      [314159265, "1121-1110-1=0"],
      [1747, "1=-0-2"],
      [906, "12111"],
      [198, "2=0="],
      [11, "21"],
      [201, "2=01"],
      [31, "111"],
      [1257, "20012"],
      [32, "112"],
      [353, "1=-1="],
      [107, "1-12"],
      [7, "12"],
      [3, "1="],
      [37, "122"]
    ].each do |int, snafu|
      assert_equal int, @d.snafu_to_integer(snafu)
      assert_equal snafu, @d.integer_to_snafu(int)
    end
  end
end
