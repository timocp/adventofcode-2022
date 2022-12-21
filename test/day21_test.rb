require "test_helper"

describe Day21 do
  def setup
    @d = Day21.new
    @d.test_input <<~TEST
      root: pppw + sjmn
      dbpl: 5
      cczh: sllz + lgvd
      zczc: 2
      ptdq: humn - dvpt
      dvpt: 3
      lfqf: 4
      humn: 5
      ljgn: 2
      sjmn: drzm * dbpl
      sllz: 4
      pppw: cczh / lfqf
      lgvd: ljgn * ptdq
      drzm: hmdt - zczc
      hmdt: 32
    TEST
  end

  def test_part1
    assert_equal 152, @d.part1
  end

  def test_part2
    assert_equal 301, @d.part2
  end
end
