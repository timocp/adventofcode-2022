#! /usr/bin/env ruby

require "./lib/aoc"

def report(title)
  print title
  t0 = Time.now
  result = yield.to_s
  time = Time.now - t0
  if result.include?("\n")
    # multiline
    puts "#{result.split("\n")[0].ljust(74 - title.length)}#{time.truncate(1)}s"
    result.split("\n").drop(1).each { |line| puts "#{" " * title.length}#{line}" }
  else
    puts "#{result.ljust(74 - title.length)}#{time.truncate(1)}s"
  end
end

(ARGV.any? ? ARGV : Aoc.days).each do |day|
  day = Aoc.handler(day)
  num = day.number.to_s.rjust(2)
  report("Day #{num} part 1: ") { day.part1 }
  report("Day #{num} part 2: ") { day.part2 } if day.respond_to?(:part2)
end
