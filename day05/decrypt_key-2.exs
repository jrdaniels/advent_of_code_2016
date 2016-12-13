defmodule Encoder do
  def process_parallel do
    0..7
    |> Enum.map(&Task.async(fn -> Encoder.process_match(0, &1) end))
    |> Enum.map(&Task.await(&1, 9000000))
    |> Enum.join
    |> IO.inspect
  end

  def process_match(count, field) do
    encoded_value = encode(count)
    cond do
      String.match?(encoded_value, ~r/^00000#{field}/) ->
        IO.puts "Found a match for #{field}:#{String.at(encoded_value, 6)}"
        String.at(encoded_value, 6)
      true ->
        process_match(count + 1, field)
    end
  end

  def encode(value) do
    Base.encode16(:crypto.hash(:md5, "wtnhxymk#{value}"))
  end

end

Encoder.process_parallel()
