class Base
  def initialize
    @raw_input = nil
  end

  def load_input
    @raw_input = File.read("input/day#{number}.txt")
  end

  def test_input(input)
    @raw_input = input
  end

  def number
    self.class.name.match(/\d+$/)[0]
  end

  attr_reader :raw_input
end
