defmodule TriangleValidator do
  def validate(input) do
    input
    |> each_triangle
    |> Enum.filter(&valid_triangle?/1)
    |> Enum.count
  end

  def each_triangle(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.chunk(3)
    |> Enum.reduce([],&rotate(&1, &2))
    |> List.flatten
  end

  def rotate(row, acc) do
    each = row
    |> Enum.map(&String.split/1)
    |> List.zip
    [each | acc]
  end

  def valid_triangle?(triangle) do
    sides = triangle |> Tuple.to_list |> Enum.map(&String.trim/1) |> Enum.map(&String.to_integer/1)
    longest_side = Enum.max(sides)
    longest_side < Enum.sum(sides) - longest_side
  end
end

System.argv
  |> hd
  |> File.read!
  |> TriangleValidator.validate
  |> IO.inspect
