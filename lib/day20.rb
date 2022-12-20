class Day20 < Base
  def part1
    mixed = mix(parse_input)
    zero_at = mixed.index(0)
    1.upto(3).map { |n| mixed[(zero_at + n * 1000) % mixed.size] }.sum
  end

  def mix(file)
    mix = file.size.times.to_a # an array of the indexes into file[]

    file.each.with_index.reject { |num, _| num == 0 }.each do |num, i|
      # puts mix.map { |m| file[m] }.inspect

      old_pos = mix.index(i)
      mix.delete_at(old_pos)
      new_pos = if num > 0
                  (old_pos + num) % mix.size
                else
                  (old_pos + num - 1) % file.size
                end
      # puts "Moving #{num} from index #{old_pos} to index #{new_pos}"
      mix.insert(new_pos, i)
    end
    # puts mix.map { |m| file[m] }.inspect

    mix.map { |m| file[m] }
  end

  def parse_input
    raw_input.each_line.map(&:to_i)
  end
end
