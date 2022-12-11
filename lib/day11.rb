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

    def [](n)
      @monkeys[n]
    end

    def dont_worry
      @worry = false
    end

    def round
      @monkeys.each.with_index do |monkey, i|
        # puts " Monkey #{i}:"
        while (item = monkey.inspect_item)
          # puts "  Monkey inspects an item with a worry level of #{item}"
          item = evaluate(monkey.operation, item) % @gcd
          item /= 3 if @worry
          # puts "    Monkey gets bored with item. Worry level is divided by 3 to #{item}"
          throw_to = if item % monkey.test_divisible_by == 0
                       # puts "    Current worry level is divisible by #{monkey.test_divisible_by}."
                       monkey.throw_if_true
                     else
                       # puts "    Current worry level is not divisible by #{monkey.test_divisible_by}."
                       monkey.throw_if_false
                     end
          # puts "    Item with worry level #{item} is thrown to monkey #{throw_to}."
          @monkeys[throw_to].items.push(item)
        end
      end
    end

    def evaluate(operation, old)
      op0 = operation[0] == "old" ? old : operation[0].to_i
      op2 = operation[2] == "old" ? old : operation[2].to_i
      case operation[1]
      when "+" then (op0 + op2) # .tap { |x| puts "    Worry level increases by #{op2} to #{x}" }
      when "*" then (op0 * op2) # .tap { |x| puts "    Worry level is multiplied by #{op2} to #{x}" }
      else
        raise "Unknown operation: #{operation.inspect}"
      end
    end

    def test_item(item, divisible_by)
      item % divisible_by
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
      monkey.operation = rules.detect { |rule| rule.first == "Operation" }.last.split.drop(2)
      monkey.test_divisible_by = rules.detect { |rule| rule.first == "Test" }.last.split.drop(2).first.to_i
      monkey.throw_if_true = rules.detect { |rule| rule.first == "If true" }.last.split.drop(3).first.to_i
      monkey.throw_if_false = rules.detect { |rule| rule.first == "If false" }.last.split.drop(3).first.to_i
    end
  end
end
