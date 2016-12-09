defmodule BathroomCode do
  @move_matrix %{
    "U" => %{ 1 => 1, 2 => 2, 3 => 3,
              4 => 1, 5 => 2, 6 => 3,
              7 => 4, 8 => 5, 9 => 6},
    "D" => %{ 1 => 4, 2 => 5, 3 => 6,
              4 => 7, 5 => 8, 6 => 9,
              7 => 7, 8 => 8, 9 => 9},
    "R" => %{ 1 => 2, 2 => 3, 3 => 3,
              4 => 5, 5 => 6, 6 => 6,
              7 => 8, 8 => 9, 9 => 9},
    "L" => %{ 1 => 1, 2 => 1, 3 => 2,
              4 => 4, 5 => 4, 6 => 5,
              7 => 7, 8 => 7, 9 => 8}
            }
  def calculate(input) do
    input
    |> parse
    |> Enum.reduce([], &process(String.graphemes(&1),&2))
    |> Enum.reverse
    |> Enum.join
  end

  def parse(directions) do
    directions
    |> String.split("\n", trim: true)
  end

  def process(steps, []) do
    [process_each(steps, 5)]
  end
  def process(steps, acc) do
    [process_each(steps, hd(acc))|acc]
  end

  def process_each([step | next], start_button) do
    new_button = move(step, start_button)
    process_each(next, new_button)
  end
  def process_each([], button), do: button

  def move(direction, location) do
    Kernel.get_in(@move_matrix, [direction, location])
  end

end

System.argv
  |> hd
  |> File.read!
  |> BathroomCode.calculate
  |> IO.inspect
