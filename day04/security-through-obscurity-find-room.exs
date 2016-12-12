defmodule RoomChecker do
  def check(input) do
    input
    |> parse_line
    |> decrypt_rooms
    |> Enum.filter(fn {name, _} -> String.match?(name, ~r/north/) end)
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

  def decrypt_rooms(rooms) do
    rooms
    |> Enum.map(&shift_room/1)
  end

  def shift_room(room), do: shift_room(room["room_name"], String.to_integer(room["sector"]))
  def shift_room(room_name, 0), do: room_name
  def shift_room(room_name, times) do
    shift_characters(room_name, times)
  end

  def shift_characters(name, times) do
    shift = rem times, 26
    unencrypted_name = String.to_charlist(name)
    |> Enum.map(&rotate(&1, shift))
    |> to_string
    {unencrypted_name, times}
  end

  def rotate(45, _shift), do: 32
  def rotate(c, shift) when c + shift > 122 do
    c + shift - 26
  end
  def rotate(c, shift) do
    c + shift
  end
end

System.argv
  |> hd
  |> File.read!
  |> RoomChecker.check
  |> IO.inspect
