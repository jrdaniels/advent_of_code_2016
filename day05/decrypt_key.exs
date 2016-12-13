defmodule Encoder do
  def encode(value) do
    Base.encode16(:crypto.hash(:md5, "wtnhxymk#{value}"))
  end

end

 0..9999999
 |> Stream.filter_map(
   fn n -> String.match?(Encoder.encode(n), ~r/^00000/) end,
   fn n -> String.at(Encoder.encode(n), 5) end)
 |> Enum.take(8)
 |> Enum.join
 |> IO.inspect
