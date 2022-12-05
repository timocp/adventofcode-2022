class Day5 < Base
  def part1
    setup
    @instructions.each do |inst|
      inst.moves.times do
        @stacks[inst.to - 1].push @stacks[inst.from - 1].pop
      end
    end
    @stacks.map(&:last).join
  end

  def part2
    setup
    @instructions.each do |inst|
      @stacks[inst.to - 1] += @stacks[inst.from - 1].slice!(-inst.moves, inst.moves)
    end
    @stacks.map(&:last).join
  end

  Instruction = Struct.new(:moves, :from, :to)

  def setup
    input = raw_input.split("\n\n")
    setup_stacks(input[0])
    setup_instructions(input[1])
  end

  def setup_stacks(input)
    @stacks = []
    input.split("\n").map do |row|
      # blocks are at position 1, 5, 9, etc
      1.step(by: 4, to: row.length).with_index do |col, i|
        crate = row[col]
        next unless crate.match?(/[A-Z]/)

        @stacks[i] ||= []
        @stacks[i].unshift crate
      end
    end
  end

  def setup_instructions(input)
    @instructions = []
    input.split("\n").each do |line|
      m = line.match(/move (\d+) from (\d+) to (\d+)/)
      @instructions << Instruction.new(m[1].to_i, m[2].to_i, m[3].to_i)
    end
  end
end
