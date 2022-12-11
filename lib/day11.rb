class Day11 < Base
  class Monkey
    def initialize
      @inspection_count = 0
    end

    attr_accessor :items, :operation, :test_divisible_by, :throw_if_true, :throw_if_false
    attr_reader :inspection_count

    def inspect_item
      @inspection_count += 1 if @items.any?
      @items.shift
    end
  end

  class MonkeyContainer
    def initialize(monkeys)
      @monkeys = monkeys
      @worry = true
      @gcd = monkeys.map(&:test_divisible_by).inject(&:*)
    end

    def dont_worry
      @worry = false
    end

    def round
      @monkeys.each do |monkey|
        while (item = monkey.inspect_item)
          item = monkey.operation.call(item) % @gcd
          item /= 3 if @worry
          throw_to = if item % monkey.test_divisible_by == 0
                       monkey.throw_if_true
                     else
                       monkey.throw_if_false
                     end
          @monkeys[throw_to].items.push(item)
        end
      end
    end

    def monkey_business
      @monkeys.map(&:inspection_count).sort[-2..].inject(&:*)
    end
  end

  def part1
    monkeys = parse_input
    20.times { monkeys.round }
    monkeys.monkey_business
  end

  def part2
    monkeys = parse_input
    monkeys.dont_worry
    10000.times { monkeys.round }
    monkeys.monkey_business
  end

  def parse_input
    MonkeyContainer.new(raw_input.split("\n\n").map { |definition| parse_monkey(definition) })
  end

  def parse_monkey(definition)
    rules = definition.split("\n").map { |rule| rule.split(":").map(&:strip) }
    Monkey.new.tap do |monkey|
      monkey.items = rules.detect { |rule| rule.first == "Starting items" }.last.split(", ").map(&:to_i)
      monkey.operation = parse_operation(*rules.detect { |rule| rule.first == "Operation" }.last.split.drop(2))
      monkey.test_divisible_by = rules.detect { |rule| rule.first == "Test" }.last.split.drop(2).first.to_i
      monkey.throw_if_true = rules.detect { |rule| rule.first == "If true" }.last.split.drop(3).first.to_i
      monkey.throw_if_false = rules.detect { |rule| rule.first == "If false" }.last.split.drop(3).first.to_i
    end
  end

  def parse_operation(op0, op1, op2)
    raise "Unexpected op0: #{op1}" unless op0 == "old"

    op = op1.to_sym
    rhs = op2 == "old" ? nil : op2.to_i
    if op2 == "old"
      proc { |old| old.send(op, old) }
    else
      proc { |old| old.send(op, rhs) }
    end
  end
end
