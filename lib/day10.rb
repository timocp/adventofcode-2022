class Day10 < Base
  class Cpu
    def initialize
      @during = [] # record of x as it was during nth cycle
      @x = 1
    end

    attr_reader :during

    def run(instructions)
      instructions.each do |instruction, arg|
        case instruction
        when :noop then noop
        when :addx then addx(arg)
        end
      end
    end

    def noop
      @during << @x
    end

    def addx(v)
      @during << @x
      @during << @x
      @x += v
    end
  end

  def part1
    cpu = Cpu.new
    cpu.run(each_instruction)
    [20, 60, 100, 140, 180, 220].sum { |c| cpu.during[c - 1] * c }
  end

  def each_instruction
    return to_enum(__method__) unless block_given?

    raw_input.each_line do |line|
      inst = line.split(" ")
      yield inst[0].to_sym, inst[1].to_i
    end
  end
end
