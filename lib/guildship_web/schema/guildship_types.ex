defmodule GuildshipWeb.Schema.GuildshipTypes do
  use Absinthe.Schema.Notation
  alias Guildship.HashId

  scalar :hashid, name: "HashID" do
    description """
    The `HashID` scalar type represents a unique identifier, often used to
    refetch an object or as key for a cache. It is not intended to be human-readable.
    When expected as an input type, any string input value will be accepted as an HashID.
    """

    serialize &encode_hashid/1
    parse &decode_hashid/1
  end

  defp encode_hashid(value) do
    HashId.encode(value)
  end

  defp decode_hashid(%Absinthe.Blueprint.Input.String{value: value}) do
    {:ok, HashId.decode(value)}
  end

  defp decode_hashid(value) do
    {:ok, HashId.decode(value)}
  end
end
