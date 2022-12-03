class Day2 < Base
  class Round
    def initialize(moves)
      @opp_move = map_move(moves[0])
      @my_move = map_move(moves[1])
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
    parse_input.map(&:score).sum
  end

  def parse_input
    @parse_input ||= raw_input.each_line.map(&:split).map { |moves| Round.new(moves) }
  end
end
