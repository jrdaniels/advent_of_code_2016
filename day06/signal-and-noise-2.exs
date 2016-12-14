defmodule Message do
  def parse(input) do
    input
    |> rotate
    |> Enum.map(&letter_count/1)
    |> Enum.join
  end

  def rotate(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce([],fn line, acc -> [String.graphemes(line) | acc] end)
    |> List.zip
  end

  def letter_count(line) do
    line
    |> Tuple.to_list
    |> Enum.reduce(Map.new, fn(letter, map) -> Map.update(map, letter, 1, &(&1 + 1)) end)
    |> Enum.sort_by(fn({_k, v}) -> v end, &<=/2 )
    |> Enum.take(1)
    |> Enum.map(fn {letter, _} -> letter end)
  end

end

System.argv
  |> hd
  |> File.read!
  |> Message.parse
  |> IO.inspect
