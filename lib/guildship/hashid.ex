defmodule Guildship.HashID do
  def hashid do
    Hashids.new(salt: Application.get_env(:guildship, :hashid_salt), min_len: 4)
  end

  def encode(val) when is_number(val) and val >= 0 do
    Hashids.encode(hashid(), val)
  end

  def encode(val) when is_binary(val) do
    encode(String.to_integer(val))
  end

  def decode(hashid) do
    Hashids.decode!(hashid(), hashid) |> hd
  end
end
