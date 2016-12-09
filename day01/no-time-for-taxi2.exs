defmodule TaxiPath do
  def calculate(input) do
    input
    |> parse
    |> move({0,0}, :N)
    |> find_first_repeat_location
    |> measure
  end

  def parse(directions) do
    directions
      |> String.split(",")
      |> Stream.map(&String.trim/1)
      |> Enum.map(&String.next_grapheme/1)
  end

  def move(steps, location, heading, history \\ [])
  def move([{lr, forward} | steps], location, heading, history) do
    new_heading = turn(heading, lr)
    {:ok, new_location, history} = each_step(location, String.to_integer(forward), new_heading, history)
    move(steps, new_location, new_heading, history)
  end
  def move([], _location, _heading, history), do: Enum.reverse(history)

  def each_step(current_location, 0, _heading, history) do
    {:ok, current_location, history}
  end
  def each_step(current_location, steps, heading, history) do
    new_location = walk(current_location, heading, 1)
    each_step(new_location, steps - 1, heading, [new_location | history])
  end

  def turn(:N, "R"), do: :E
  def turn(:N, "L"), do: :W
  def turn(:E, "R"), do: :S
  def turn(:E, "L"), do: :N
  def turn(:S, "R"), do: :W
  def turn(:S, "L"), do: :E
  def turn(:W, "R"), do: :N
  def turn(:W, "L"), do: :S

  def walk({x,y}, :N, amount), do: {x, y + amount}
  def walk({x,y}, :E, amount), do: {x + amount, y}
  def walk({x,y}, :S, amount), do: {x, y - amount}
  def walk({x,y}, :W, amount), do: {x - amount, y}

  def find_first_repeat_location([location | later_steps]) do
    if Enum.member?(later_steps, location) do
      location
    else
      find_first_repeat_location(later_steps)
    end
  end
  def find_first_repeat_location([]), do: {:error, "We didn't find one"}

  def measure({new_x, new_y}), do: abs(new_x) + abs(new_y)

end

System.argv
  |> hd
  |> File.read!
  |> TaxiPath.calculate
  |> IO.inspect
