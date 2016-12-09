defmodule TaxiPath do
  def calculate(input) do
    input
    |> parse
    |> move({0,0}, :N)
    |> measure
  end

  def parse(directions) do
    directions
      |> String.split(",")
      |> Stream.map(&String.trim/1)
      |> Enum.map(&String.next_grapheme/1)
  end

  def move([{lr, forward} | steps], location, heading) do
    new_heading = turn(heading, lr)
    new_location = walk(location, new_heading, String.to_integer(forward))
    move(steps, new_location, new_heading)
  end

  def move([], location, _heading), do: location

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

  def measure({new_x, new_y}), do: abs(new_x) + abs(new_y)

end

System.argv
  |> hd
  |> File.read!
  |> TaxiPath.calculate
  |> IO.inspect
