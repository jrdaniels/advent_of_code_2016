 0..9999999 |> Stream.filter(fn n -> String.match?(Base.encode16(:crypto.hash(:md5, "wtnhxymk#{n}")), ~r/^00000/) end) |> Enum.take(8) |> Enum.map(&Base.encode16(:crypto.hash(:md5, "wtnhxymk#{&1}")))
