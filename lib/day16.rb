class Day16 < Base
  START = :AA

  Valve = Struct.new(:number, :name, :flow_rate, :tunnels)

  State = Struct.new(:time, :location, :pressure, :total, :open) do
    # returns new state after moving to and opening a closed valve
    def move_to(v, steps)
      self.class.new(
        time + steps + 1,
        v.name,
        pressure + v.flow_rate,
        total + pressure * (steps + 1),
        open | 1 << v.number
      )
    end

    # returns new state after waiting here until the time limit
    def wait
      self.class.new(
        30,
        location,
        pressure,
        total + pressure * (30 - time),
        open
      )
    end

    def to_s
      "Minute #{time} player at #{location}, releasing #{pressure} (total #{total}) open=#{open.to_s(2)}"
    end
  end

  def generate_diagrams
    File.open("original.dot", "w") do |dot|
      dot.puts "graph day16 {"
      valves.values.sort_by(&:name).each do |v|
        dot.puts "    #{v.name} [color=orange style=filled]" if v.name == START
        dot.puts "    #{v.name} [label=\"#{v.name} #{v.flow_rate}\" color=green style=filled]" if v.flow_rate
        v.tunnels.each do |tunnel|
          raise "x" unless valves[tunnel].tunnels.include?(v.name)
          next if v.name > valves[tunnel].name

          dot.puts "    #{v.name} -- #{tunnel}"
        end
      end
      dot.puts "}"
    end
    system("dot -Tpng original.dot > original.png")

    File.open("reduced.dot", "w") do |dot|
      dot.puts "graph day16 {"
      graph.keys.sort.each do |from|
        graph[from].each do |to, length|
          next if to < from

          dot.puts "    #{from} -- #{to} [label=\"#{length}\"]"
        end
      end
      dot.puts "}"
    end
    system("dot -Tpng reduced.dot > reduced.png")
  end

  # find a state that maximises pressure after 30 minutes
  def part1
    # generate_diagrams
    dfs_pressure(State.new(0, START, 0, 0, 0))
  end

  # we only care about movement between START and nodes with positive flow rates
  # compose a new graph where edges are the number of steps between nodes
  # that have a positive flow rate
  def graph
    @graph ||= valves.values.select { |v| v.name == START || v.flow_rate }
                     .each_with_object({}) { |v, graph| find_paths(v.name, graph) }
  end

  def find_paths(start, graph)
    queue = [start]
    visited = { queue.first => nil }
    while (name = queue.shift)
      valves[name].tunnels.each do |tunnel|
        next if visited.key?(tunnel)

        queue.push(tunnel)
        visited[tunnel] = name
      end
    end

    graph[start] = Hash[valves.values.select { |v| v.flow_rate && visited[v.name] }.map do |v|
      [v.name, count_steps(visited, v.name)]
    end]
  end

  def count_steps(visited, name)
    list = [name]
    while (prev = visited[list.last])
      list << prev
    end
    list.size - 1
  end

  # returns the highest total pressure found in any path through the graph
  def dfs_pressure(state)
    # if all valves are open, just wait here at max pressure
    return state.wait.total if state.open == all_open

    graph[state.location].map do |tunnel, steps|
      to = valves[tunnel]
      next if state.time + steps + 1 > 30
      next if state.open & 1 << to.number > 0

      dfs_pressure(state.move_to(to, steps))
    end.compact.max || state.wait.total
  end

  def valves
    @valves ||= Hash[
      raw_input.each_line
               .map { |line| line.match(/^Valve (\S\S) has flow rate=(\d+); tunnels? leads? to valves? (.*)$/) }
               .each_with_index
               .map { |m, i| Valve.new(i, m[1].to_sym, m[2] == "0" ? nil : m[2].to_i, m[3].split(", ").map(&:to_sym)) }
               .map { |v| [v.name, v] }
    ]
  end

  def all_open
    @all_open ||= valves.values.select(&:flow_rate).map { |v| 1 << v.number }.inject(&:|)
  end
end
