class Day2 < Base
  class Round
    def initialize(moves, part)
      @opp_move = map_move(moves[0])
      @my_move =
        if part == 1
          map_move(moves[1])
        else
          choose_move(moves[1])
        end
    end

    BEATS = {
      rock: :scissors,
      paper: :rock,
      scissors: :paper
    }.freeze

    def shape_score
      { rock: 1, paper: 2, scissors: 3 }[@my_move]
    end

    def outcome_score
      if @my_move == @opp_move
        3 # draw
      elsif BEATS[@my_move] == @opp_move
        6 # win
      else
        0 # loss
      end
    end

    def score
      shape_score + outcome_score
    end

    def choose_move(instruction)
      case instruction
      when "X" then BEATS[@opp_move]        # need to lose
      when "Y" then @opp_move               # need to draw
      when "Z" then BEATS.invert[@opp_move] # need to win
      end
    end

    def map_move(move)
      case move
      when "A", "X" then :rock
      when "B", "Y" then :paper
      when "C", "Z" then :scissors
      else
        raise ArgumentError, "invalid move: #{move}"
      end
    end
  end

  def part1
    parse_input.map { |moves| Round.new(moves, 1) }.map(&:score).sum
  end

  def part2
    parse_input.map { |moves| Round.new(moves, 2) }.map(&:score).sum
  end

  def parse_input
    @parse_input ||= raw_input.each_line.map(&:split)
  end
end
