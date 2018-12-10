defmodule Guildship.HashId do
  defp hashid do
    default_alphabet =
      [
        "1234567890",
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        "abcdefghijklmnopqrstuvwxyz"
      ]
      |> Enum.join()

    alphabet =
      Application.get_env(:guildship, :hashid_alphabet, default_alphabet)

    min_length = Application.get_env(:guildship, :hashid_min_length, 4)
    salt = Application.get_env(:guildship, :hashid_salt, "**salt**")
    Hashids.new(min_len: min_length, salt: salt, alphabet: alphabet)
  end

  def encode(value), do: "gs1-" <> Hashids.encode(hashid(), [value])
  def decode("gs1-" <> value), do: hd(Hashids.decode!(hashid(), value))
end
