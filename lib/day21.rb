class Day21 < Base
  class Monkey
    def initialize(command)
      if command.match(/^\d+$/)
        @number = command.to_i
      else
        @args = command.split.map(&:to_sym)
        @op = @args.delete_at(1)
      end
    end

    attr_reader :number, :args, :op

    def display
      if number
        number.to_s
      else
        "#{args[0]} #{op} #{args[1]}"
      end
    end
  end

  class MonkeyGroup
    def initialize(monkeys)
      @monkeys = monkeys
    end

    def yell(name)
      monkey = @monkeys[name]
      monkey.number || monkey.args.map { |m| yell(m) }.inject(&monkey.op)
    end

    def calc_human_yell
      root = @monkeys[:root]
      if depends?(root.args[0], :humn)
        calc_yell(root.args[0], yell(root.args[1]))
      else
        calc_yell(root.args[1], yell(root.args[0]))
      end
    end

    # first call will be like:
    # calc_yell(name: :pppw, result: 150)
    #
    # final call to this will be:
    # calc_yell(name: :ptdq, result: 298)
    def calc_yell(name, result)
      # puts "yell from #{name} (#{@monkeys[name].display}) needs to yield #{result}"
      monkey = @monkeys[name]
      if monkey.args[0] == :humn
        # humn is the LHS of this op
        case monkey.op
        when :+ then result - yell(monkey.args[1])
        when :- then result + yell(monkey.args[1])
        when :* then result / yell(monkey.args[1])
        when :/ then result * yell(monkey.args[1])
        end
      elsif monkey.args[1] == :humn
        # humn is the RHS of this op
        case monkey.op
        when :+ then result - yell(monkey.args[1])
        when :- then yell(monkey.args[1]) - result
        when :* then result / yell(monkey.args[1])
        when :/ then yell(monkey.args[1]) / result
        end
      elsif depends?(monkey.args[0], :humn)
        # humn is further down the LHS
        case monkey.op
        when :+ then calc_yell(monkey.args[0], result - yell(monkey.args[1]))
        when :- then calc_yell(monkey.args[0], result + yell(monkey.args[1]))
        when :* then calc_yell(monkey.args[0], result / yell(monkey.args[1]))
        when :/ then calc_yell(monkey.args[0], result * yell(monkey.args[1]))
        end
      elsif depends?(monkey.args[1], :humn)
        # humn is further down the RHS
        case monkey.op
        when :+ then calc_yell(monkey.args[1], result - yell(monkey.args[0]))
        when :- then calc_yell(monkey.args[1], yell(monkey.args[0]) - result)
        when :* then calc_yell(monkey.args[1], result / yell(monkey.args[0]))
        when :/ then calc_yell(monkey.args[1], yell(monkey.args[0]) / result)
        end
      else
        raise "shouldn't happen"
      end
    end

    def depends?(from, to)
      monkey = @monkeys[from]
      if monkey.number
        false
      elsif monkey.args.include?(to)
        true
      else
        monkey.args.any? { |a| depends?(a, to) }
      end
    end
  end

  def part1
    parse_input.yell(:root)
  end

  def part2
    parse_input.calc_human_yell
  end

  def parse_input
    MonkeyGroup.new(
      Hash[raw_input.each_line.map(&:chomp).map do |line|
        name, command = line.split(": ")
        [name.to_sym, Monkey.new(command)]
      end]
    )
  end
end
