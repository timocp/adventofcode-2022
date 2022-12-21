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
  end

  def part1
    yell(parse_input, :root)
  end

  def yell(monkeys, name)
    monkey = monkeys[name]

    monkey.number || monkey.args.map { |m| yell(monkeys, m) }.inject(&monkey.op)
  end

  def parse_input
    Hash[raw_input.each_line.map(&:chomp).map do |line|
      name, command = line.split(": ")
      [name.to_sym, Monkey.new(command)]
    end]
  end
end
