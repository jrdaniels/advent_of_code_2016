defmodule IP7 do
  def validate(input) do
    input
    |> get_addresses
    |> Enum.filter(&filter_abba_in_hypernet(&1))
    |> Enum.filter(&contains_abba?/1)
    # |> Enum.filter(fn line -> String.match?(line, ~r/\[.*?[^\]]*?(.)(?!\1)(.)\2\1.*?\]/) end)
    # |> Enum.map(&Regex.replace(~r/\[.*?[^\]]*?(.)(?!\1)(.)\2\1.*?\]/, &1, "**\\0**"))
    # |> Enum.filter(fn line -> String.match?(line, ~r/(.)(?!\1)(.)\2\1/ ) end)
  end

  def get_addresses(input) do
    input
    |> String.split("\n", trim: true)
  end

  def filter_abba_in_hypernet(address) do
    address
    |> String.split(["[","]"])
    |> Enum.drop_every(2)
    |> Enum.filter(&contains_abba?/1)
    |> Enum.empty?
  end

  def contains_abba?(string) do
    String.match?(string, ~r/(.)(?!\1)(.)\2\1/ )
  end

end


System.argv
  |> hd
  |> File.read!
  |> IP7.validate
  |> Enum.count
  |> IO.inspect
