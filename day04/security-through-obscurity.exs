defmodule RoomChecker do
  def check(input) do
    input
    |> parse_line
    |> Enum.map(fn room -> String.to_integer(room["sector"]) end)
    |> Enum.sum
  end

  def parse_line(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&set_fields(&1))
    |> Enum.filter(&is_room_valid?/1)
  end

  def set_fields(line) do
    Regex.named_captures(~r/(?<room_name>.+)-(?<sector>.*?)\[(?<checksum>.*)\]/, line)
  end

  def is_room_valid?(room) do
    room["checksum"] == calculate_checksum(room["room_name"])
  end

  def calculate_checksum(room_name) do
    room_name
    |> String.graphemes
    |> Enum.filter(fn letter -> letter != "-" end)
    |> Enum.reduce(Map.new, fn(letter, map) -> Map.update(map, letter, 1, &(&1 + 1)) end)
    |> Enum.sort_by(fn({_k, v}) -> v end, &>=/2 )
    |> Enum.map(&hd(Tuple.to_list(&1)))
    |> Enum.take(5)
    |> Enum.join
  end
end


System.argv
  |> hd
  |> File.read!
  |> RoomChecker.check
  # |> Enum.sum
  |> IO.inspect
