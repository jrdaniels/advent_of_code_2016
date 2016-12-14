defmodule IP7 do
  def validate(input) do
    input
    |> get_addresses
    |> Enum.filter(fn line -> !String.match?(line, ~r/\[.*?[^\]]*?(.)(?!\1)(.)\2\1.*?\]/) end)
    |> Enum.filter(fn line -> String.match?(line, ~r/(.)(?!\1)(.)\2\1/ ) end)
  end

  def get_addresses(input) do
    input
    |> String.split("\n", trim: true)
  end

end


System.argv
  |> hd
  |> File.read!
  |> IP7.validate
  |> Enum.count
  |> IO.inspect
