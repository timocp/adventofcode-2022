#! /bin/sh

set -e

mkdir -p lib test

day=$1

if [ "$day" = "" ]; then
    day=$(TZ=US/Eastern date '+%d' | sed 's/^0//')
fi

input="input/day$day.txt"
lib="lib/day$day.rb"
tst="test/day${day}_test.rb"

if ! git diff --exit-code > /dev/null; then
    echo "There are uncommitted changes" 2>&1
    exit 1
fi
if [ -e "$lib" ]; then
    echo "Already exists: $lib" 2>&1
    exit 1
fi

./download.sh

echo "Creating $lib..."
cat > "$lib" <<EOF
class Day$day < Base
  def part1
    binding.irb
  end
end
EOF

echo "Creating $tst..."
cat > "$tst" <<EOF
require "test_helper"

describe Day$day do
  def setup
    @d = Day$day.new
    @d.test_input <<~TEST
    TEST
  end

  def test_part1
    assert_equal 0, @d.part1
  end
end
EOF

less "$input"
