class Day7 < Base
  def part1
    tree = parse_input
    calc_size(tree)
    # each_directory(tree) do |name, size|
    #   warn [name, size].inspect
    # end
    each_directory(tree).map { |_name, size| size }.select { |size| size <= 100000 }.sum
  end

  def part2
    tree = parse_input
    calc_size(tree)

    disk_size = 70000000
    needed_space = 30000000
    unused_space = disk_size - tree[:size]
    need_to_free = needed_space - unused_space
    each_directory(tree).map { |_name, size| size }.select { |size| size >= need_to_free }.min
  end

  # measure (and cache) size of each directory
  def calc_size(tree)
    tree[:size] ||=
      tree.values.sum do |v|
        if v.is_a?(Hash)
          calc_size(v)
        else
          v
        end
      end
  end

  # yields [path, size] for each directory
  def each_directory(tree, path = "/", &block)
    return to_enum(__method__, tree, path) unless block_given?

    yield path, tree[:size]
    tree.each_key do |name|
      each_directory(tree[name], "#{path}/#{name}", &block) if tree[name].is_a?(Hash)
    end
  end

  # returns: Nested hash of: { filename => size, dirname => {} }
  def parse_input
    tree = {}
    path = []
    raw_input.split("$ ").map(&:chomp).reject(&:empty?).each do |part|
      command, output = part.split("\n", 2)
      cmd = command.split(" ", 2)
      case cmd[0]
      when "cd"
        case cmd[1]
        when ".." then path.pop
        when "/"  then path = []
        else
          path.push cmd[1]
        end
      when "ls"
        output.split("\n").each do |line|
          type_or_size, name = line.split(" ")
          (path.any? ? tree.dig(*path) : tree)[name] =
            if type_or_size == "dir"
              {}
            else
              type_or_size.to_i
            end
        end
      else
        raise "invalid command: #{command}"
      end
    end
    tree
  end
end
