#! /bin/sh

set -e

mkdir -p input lib test

year=2022
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
elif [ -e "$input" ]; then
    echo "Already have day $day" 2>&1
    exit 1
fi

# download input (assumes w3m is already logged in)
url="https://adventofcode.com/$year/day/$day/input"
echo "Fetching $url..."
w3m "$url" > "$input"
file "$input"

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

describe Day$day
  def setup
    @d = Day$day.new
  end

  def test_part1
    assert_equal 0, @d.part1
  end
end
EOF

less "$input"
