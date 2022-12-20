class Day20 < Base
  def part1
    decrypt(parse_input)
  end

  def part2
    decrypt(parse_input, rounds: 10, key: 811589153)
  end

  def decrypt(file, rounds: 1, key: 1)
    mixed = mix(file.map { |num| num * key }, rounds: rounds)
    zero_at = mixed.index(0)
    1.upto(3).map { |n| mixed[(zero_at + n * 1000) % mixed.size] }.sum
  end

  def mix(file, rounds:)
    mix = file.size.times.to_a # an array of the indexes into file[]

    rounds.times do
      file.each.with_index.reject { |num, _| num == 0 }.each do |num, i|
        old_pos = mix.index(i)
        mix.delete_at(old_pos)
        mix.insert((old_pos + num) % mix.size, i)
      end
    end

    mix.map { |m| file[m] }
  end

  def parse_input
    raw_input.each_line.map(&:to_i)
  end
end
