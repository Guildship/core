defmodule Guildship.HashId do
  defp hashid do
    default_alphabet =
      "_-" <>
        "1234567890" <>
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ" <>
        "abcdefghijklmnopqrstuvwxyz"

    alphabet =
      Application.get_env(:guildship, :hashid_alphabet, default_alphabet)

    min_length = Application.get_env(:guildship, :hashid_min_length, 4)
    salt = Application.get_env(:guildship, :hashid_salt, "**salt**")
    Hashids.new(min_len: min_length, salt: salt, alphabet: alphabet)
  end

  def encode(value), do: "1g" <> Hashids.encode(hashid(), [value])
  def decode("1g" <> value), do: hd(Hashids.decode!(hashid(), value))
  def decode(value), do: value
end
