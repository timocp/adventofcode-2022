$LOAD_PATH << File.dirname(__FILE__)
require "base"
Dir.glob("#{File.dirname(__FILE__)}/day*.rb").sort.map { |lib| require File.basename(lib, ".rb") }

class Aoc
  def self.handler(day)
    Object.const_get("Day#{day}").new.tap(&:load_input)
  end

  def self.days
    Dir.entries("input")
       .reject { |f| f.start_with?(".") }
       .map { |f| f.match(/(\d+)/)[1] }
       .map(&:to_i)
       .sort
  end
end
